32-bit uDLX
============

The uDLX (said micro-DeLuX) is a 32-bit simple RISC-type architecture. It features a minimal instruction set, relatively few addressing modes, and a processor organization designed to simplify implementation. Its architecture was designed to be reusable and the implementation strategy was based on incremental improvements in order to produce several designs.

Design Overview
------------

The uDLX hardware structure has a five-deep pipeline architecture, and was highly designed to cover mid-low complexity applications. The uDLX is a 32-bit word- oriented system. Its architecture has 16 GPR (General Purpose Registers) in a register file. Two of these registers are reserved for special purposes. Register 0 always contains zero. It can be used as a source operand whenever zero is needed, and stores to it have no effect. Register 31 is reserved for use by some uDLX instructions, as will be described shortly. uDLX also has a 32 bit program counter.

DLX is built under the perspective of RISC Load-Store/Register-Register processor architecture. CPU instructions are 32-bits long word and organized into the following functional groups:

* Load and store
* Computational
* Jump and branch

Pipeline Architecutre
------------

The DLX core processor uses a five-deep parallel pipeline on its architecture. The current pipeline is divided into the following stages:

* Instruction Fetch
* Instruction Decode
* Arithmetic operation (Execution)
* Memory access
* Write back
