
module sdram_fsm (
    
    input wr_en,
    input rd_en,
    input [31:0] data,
    input [31:0] addr,
    output data

    // SDRAM control signals
    output reg [ 1:0] sdClkE,
    output reg        sdWeN,
    output reg        sdCasN,
    output reg        sdRasN,
    output reg        sdCsN,
    output reg [11:0] sdA,
    output reg [ 1:0] sdBa,
    output reg [ 3:0] sdDqm,
    input      [31:0] sdDqIn,
    output reg [31:0] sdDqOut,
    output reg        sdDqOeN
  );



 parameter IDLE               =  0;
 parameter PRE_CHARGE         =  1;
 parameter WAIT_FOR_RP        =  2;
 parameter AUTO_REFRESH       =  3;
 parameter LOAD_MODE          =  4;
 parameter ACTIVE             =  5;
 parameter RAS_TO_CAS         =  6;
 parameter READ_INIT          =  7;
 parameter WRITE_INIT         =  8;
 parameter CAS_LAT            =  9;
 parameter READ_DATA          = 10;
 parameter BURST_TERM         = 11;


// controller engine state machine
always @ (posedge sdClk or negedge rstN) begin
    if (!rstN) begin
        presState  <= IDLE;
        brstCntr   <= 9'd0;
        counter   <= 4'b0000;
        rfshed     <= 1'b0;
        instrFifoRead <= 1'b0;
      //sdClkE     <= 2'b11;
        sdWeNQ      <= 1'b1;
        sdCasN     <= 1'b1;
        sdRasN     <= 1'b1;
        sdCsN      <= 1'b1;
        sdA        <= 12'd0;
        sdBa       <= 2'b00;
        sdDqm      <= 4'b1111;
        sdDqOeN    <= 1'b1;
        accWasWrite <= 1'b0;
        writing    <= 1'b0;

	initialize <= 1'b1;
    end
    else begin
        writing    <= 1'b0;

        presState  <= nextState;             // state transition

        accWasWrite <= accIsWrite;

        rfshed     <= 1'b0;                  // strobes

        case (nextState)
	    IDLE : begin
                sdCsN  <= 1'b1;
                sdRasN <= 1'b1;
                sdCasN <= 1'b1;
                sdWeNQ  <= 1'b1;
                sdDqm  <= 4'b1111;
            end
            PRE_CHARGE: begin
                sdCsN    <= 1'b0;
                sdRasN   <= 1'b0;
                sdCasN   <= 1'b1;
                sdWeNQ    <= 1'b0;
                sdA[10]  <= 1'b1;               // all-bank precharge
                counter <= {1'b0,rp};          // precharge command period
            end
            WAIT_FOR_RP: begin
                sdCsN    <= 1'b0;
                sdRasN   <= 1'b1;
                sdCasN   <= 1'b1;
                sdWeNQ    <= 1'b1;
                sdDqm    <= 4'b1111;
                sdDqOeN  <= 1'b1;
                counter <= counter - 1'b1;
            end
            AUTO_REFRESH: begin
                sdCsN    <= 1'b0;
                sdRasN   <= 1'b0;
                sdCasN   <= 1'b0;
                sdWeNQ    <= 1'b1;
                counter <= rfc;     // minimum refresh period
                rfshed   <= 1'b1;
            end
            LOAD_MODE: begin
                sdCsN  <= 1'b0;
                sdRasN <= 1'b0;
                sdCasN <= 1'b0;
                sdWeNQ  <= 1'b0;
                sdA    <= mode0val;
                sdBa   <= 2'b00;

		initialize <= 1'b0;
            end
            ACTIVE: begin
                sdCsN      <= 1'b0;
                sdRasN     <= 1'b0;
                sdCasN     <= 1'b1;
                sdWeNQ      <= 1'b1;

                //     controlled by : row signal
                sdBa       <= accAddr[12:11];   // bank
                sdA        <= accAddr[24:13];
                // Note that it is assumed that burst will be all on same row
//                rowActive  <= accAddr[24:13];   // record active row

                counter <= rcd;            // active to R/W delay
                brstCntr <= 9'd0;
//                lastPage <= accAddr[24:11]; // for page hit detection
            end
            RAS_TO_CAS: begin
                sdCsN    <= 1'b0;
                sdRasN   <= 1'b1;
                sdCasN   <= 1'b1;
                sdWeNQ    <= 1'b1;
                counter <= counter - 1'b1;
            end
            READ_INIT: begin
                sdCsN    <= 1'b0;
                sdRasN   <= 1'b1;
                sdCasN   <= 1'b0;
                sdWeNQ    <= 1'b1;
                sdDqm    <= sdDqm_c; 

                // Note that it is assumed that burst will be all on same row
                //     controlled by : col signal
                sdBa     <= accAddr[12:11];   // bank
                sdA[10]  <= 1'b0;             // auto precharge disabled
                sdA[8:0] <= accAddr[10: 2];   // colAddr[8:0]


                counter   <= {1'b0,cl - 1'b1}; // cas latency
            end
            WRITE_INIT: begin
                writing  <= 1'b1;
                sdCsN    <= 1'b0;
                sdRasN   <= 1'b1;
                sdCasN   <= 1'b0;
                sdWeNQ    <= 1'b0;
                sdDqm    <= sdDqm_c;

                // Note that it is assumed that burst will be all on same row
                //     controlled by : col signal
                sdBa     <= accAddr[12:11];   // bank
                sdA[10]  <= 1'b0;             // auto precharge disabled
                sdA[8:0] <= accAddr[10: 2];   // colAddr[8:0]

                sdDqOeN    <= 1'b0;
                counter   <= {1'b0,wr};
            end
            CAS_LAT: begin
                sdCsN   <= 1'b0;
                sdRasN  <= 1'b1;
                sdCasN  <= 1'b1;
                sdWeNQ   <= 1'b1;
                counter <= counter - 1'b1;
            end
            READ_DATA: begin

                sdCsN    <= 1'b0;   // NOP
                sdRasN   <= 1'b1;
                sdCasN   <= 1'b1;
                sdWeNQ    <= 1'b1;

                sdDqm <= 4'b0000;
                sdA[8:0] <= accAddr[10: 2];   // colAddr[8:0]
                brstCntr  <= brstCntr + 1'b1;
            end
            BURST_TERM: begin
                sdCsN   <= 1'b0;
                sdRasN  <= 1'b1;
                sdCasN  <= 1'b1;
                sdWeNQ   <= 1'b0;
                sdDqm   <= 4'b1111;
            end
            default: begin
                sdCsN  <= 1'b1;
                sdRasN <= 1'b1;
                sdCasN <= 1'b1;
                sdWeNQ  <= 1'b1;
                sdDqm  <= 4'b1111;
                instrFifoRead <= 1'b0;
            end
        endcase
    end
end

// next state calculation
always @ (*) begin
    engRdDataRdy = 1'b0;
    case (presState)
        IDLE: begin
            if(initialize)
	      nextState = PRECHRG;
            else if(wr | rd)
	       nextState = ACTIVE;
            else
	       nextState = IDLE;
        end
        PRE_CHARGE: begin
            nextState = WAIT_FOR_RP;
        end
        WAIT_FOR_RP: begin
            if (counter != 4'd0) nextState = WAIT_FOR_RP;
            else begin
                if (initialize)
		   nextState = AUTO_REFRESH;
                else
		   nextState = IDLE;
            end
        end
        AUTO_REFRESH: begin
	    if(counter != 4'd0)
               nextState = AUTO_REFRESH;
	    else if(initialize)
	       nextState = LOAD_MODE;
	    else
	       nextState = IDLE;
        end
        LOAD_MODE: begin
            nextState = IDLE;
        end
        ACTIVE: begin
            nextState = RAS_TO_CAS;
        end
        RAS_TO_CAS: begin
            if (counter != 4'd0) nextState = RAS_TO_CAS;
            else begin
                if (accIsWrite) nextState = WRITE_INIT;
                else            nextState = READ_INIT;
            end
        end
        READ_INIT: begin
            nextState = CAS_LAT;
        end
        WRITE_INIT: begin
            if (accBurstTerm)
                nextState = BURST_TERM;
            else
                nextState = WRITE_DATA;
        end
        CAS_LAT: begin
            if (counter != 4'd0)
                nextState = CAS_LAT;
            else begin
                engRdDataRdy = 1'b1;
                nextState = READ_DATA;
            end
        end
        READ_DATA: begin
            engRdDataRdy = 1'b1;
            if (accBurstTerm)
                nextState = BURST_TERM;
            else
                nextState = READ_DATA;
        end
        WRITE_DATA: begin
            if (accBurstTerm)
                nextState = BURST_TERM;
            else
                nextState = WRITE_DATA;
        end
        BURST_TERM: begin
            engRdDataRdy = 1'b0;
            nextState = PRE_CHARGE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

endmodule
