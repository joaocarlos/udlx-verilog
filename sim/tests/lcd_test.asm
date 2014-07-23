#init LCD

init:
nop
nop
nop
nop
nop
nop
nop



#end add delay


#define LCD_EN_ON gpio->GPIO_SET_ST =  0x0100
#define LCD_EN_OFF gpio->GPIO_CLR = 0x0100
#define LCD_EN_PULSE LCD_EN_ON; msleep(1); LCD_EN_OFF
#define LCD_RS_ON gpio->GPIO_SET_ST = 0x0200
#define LCD_RS_OFF gpio->GPIO_CLR = 0x0200
#define LCD_DATA(value) gpio->GPIO_SET_ST = (unsigned char) value; gpio->GPIO_CLR = (unsigned char) ~value

#   lcd_cmd(0x03);
#   lcd_cmd(0x03);
#   lcd_cmd(0x03);

#   lcd_cmd(0x38); // 8bits - 2 lines
#   lcd_cmd(0x0D); // cursor blinking
#   lcd_cmd(0x0E); // cursor on
#   lcd_cmd(0x0F); // cursor blinking

#SEND COMMAND -- CONFIGURE LCD
   #LCD_RS_OFF;
      andi $5, $5, 0x00000000 
      sw $5 0xFFFFFFFF # LCD_RS_OFF;
      #add delay 
         andi $3, $1, 0x00000000 #zerando
         andi $1, $1, 0x00000000 #zerando
         addi $2, $3, 100 #inicializando delay
         nop
         wait0:
         addi $1, $1, 1 #contando
         sub $3, $2, $1
         bnez $3, wait0
         nop
   #LCD CMD
      andi $5, $5, 0x00000000
      addi $5, $5, 0x03 #send CMD;
      sw $5 0xFFFFFFFF
      nop
      nop
      #add delay
         andi $3, $1, 0x00000000 #zerando
         andi $1, $1, 0x00000000 #zerando
         addi $2, $3, 100 #inicializando delay
         nop
         wait1:
         addi $1, $1, 1 #contando
         sub $3, $2, $1
         bnez $3, wait1
         nop
   #LCD_EN PULSE;
      addi $6, $6, 0x100 # LCD_EN ON
      or $6, $6, $5 # LCD_EN ON
      sw $6 0xFFFFFFFF
      nop
      #add delay
         andi $3, $1, 0x00000000 #zerando
         andi $1, $1, 0x00000000 #zerando
         addi $2, $3, 100 #inicializando delay
         nop
         wait2:
         addi $1, $1, 1 #contando
         sub $3, $2, $1
         bnez $3, wait2
         nop
      andi $5, $5, 0x000000FF # LCD_EN OFF
      sw $5 0xFFFFFFFF
nop
nop
nop
nop
nop
nop
