0xFFFFua: 16-bit RISC softprocessor
===================================

 **Current version**: 0.9 RC.  
   **Target device**: Xilinx Spartan-3E FPGA (Xilinx Spartan-3E Starter Kit).  
       **Software** : Xilinx ISE 13.4 (webpack).  
**Tested frequency**: 50 MHz.  

Synopsis
--------

Simple 16-bit RISC softprocessor designed for academic purposes.

**Registers**: 32 general purpose registers.  
**Flags**: Carry, zero.  
**RAM**: 512 words.  
**ROM**: 512 words.  
**Instruction pointer** : 9 bit for direct addressing (covers 512 addresses) and
relative addressing (covers +255 and -256 addresses). Has internal 32-deep stack
which allows to store 32 addresses and flags.  
**Peripherals**: Addressing up to 32 peripheral devices.  


Supported commands
------------------

**1. Arithmetical** (operate with signed numbers)

1.1 **add** : Addition.  
1.2 **addc**: Addition with carry flag.  
1.3 **sub** : Substraction.  
1.4 **subc**: Substraction with carry flag.  
1.5 **neg** : Negativation (multiply by -1).  
1.6 **mul** : Multiplication.  
1.7 **div** : Division (result: quotient (div) and remainder (mod)).  
1.8 **cmp** : Substraction without saving result;  


**2. Logical**

2.1 **and**  : Logical conjunction.  
2.2 **or**   : Logical disjunction.  
2.3 **xor**  : Exclusive disjunction;  
2.4 **test** : Logical conjunction without saving result;  


**3. Shifting**

3.1 **sl0** : Shift left and set LSB to 0.  
3.2 **sl1** : Shift left and set LSB to 1.  
3.3 **slx** : Shift left and set LSB to it's previous value.  
3.4 **slc** : Shift left and set LSB to carry flag value.  
3.5 **sr0** : Shift right and set MSB to 0.  
3.6 **sr1** : Shift right and set MSB to 1.  
3.7 **srx** : Shift right and set MSB to it's previous value.  
3.8 **src** : Shift right and set MSB to carry flag value.  
3.9 **rl**  : Roll left.  
3.10 **rr**  : Roll right.  


**4. Jumping**

4.1 **jmp**  : Short jump.  
4.2 **jmpl** : Long jump.  
4.3 **jz**   : Short jump if zero flag = 1 (equality).  
4.4 **jnz**  : Short jump if zero flag = 0 (not equality).  
4.5 **jc**   : Short jump if carry flag = 1.  
4.6 **jnc**  : Short jump if carry flag = 0.  
4.7 **ja**   : Short jump if above.  
4.8 **jb**   : Short jump if below.  
4.9 **call** : Subprogram call.  
4.10 **ret**  : Subprogram return.  


**5. Data transferring**

5.1 **cpy** : Copy from one register to another.  
5.2 **ld**  : Load data from RAM to register.  
5.3 **ud**  : Upload data to RAM from register.  
5.4 **li**  : Load immediately data from ROM to register.  
5.5 **in**  : Load data from peripheral device to register.  
5.6 **out** : Upload data from register to peripheral device.  


**6. Other**

6.1 **nop** : No operation.


Environment
-----------

CPU can be tested on SoC which was developed for this purpose. SoC includes:  
1. **LED line**.  
2. **Switch line**.  
3. **LCD** module.  
4. **UART** module (female connector).  
