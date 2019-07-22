# KENNYOS

<div style="text-align:center"><img src="https://kennethkobz.files.wordpress.com/2019/05/kennyos.png" /></div>

<b>What is KENNYOS?</b> <br/>
KENNYOS is a bare-bones operating system built for Intel x86 computers. <br/>

<b>What programming language(s) are used?</b> <br/>
 -> Assembly (NASM x86 syntax)

<b>What compilation tools are used to build KENNYOS?</b> <br/>
 -> NASM <br/>
 -> MagicISO <br/>
 -> ImDisk <br/>
 
<b>Where does the OS run from?</b> </br>
 -> Virtual ISO <br/>
 -> Virtual Floppy Image <br/>
 -> USB Stick <br/>
 -> Physical 3.5" 1.44MB Floppy Diskette <br/>
 -> Physical CD/DVD <br/>
 
<b>How do I compile?</b>
 -> Open NasmPath from Desktop and move into project directory <br/>
 ** If you don't have a NasmPath shell, visit NASM.us and download the NASM Installer <br/>

 -> Compile the BOOT.ASM file using the following command <br/>
	
		nasm -f bin -o kennyos.img BOOT.ASM
		
<br/>
-> Compile the KERNEL.SYS file using the following command <br/>
	
		nasm -f bin -o kernel.sys KERNEL.ASM
		
 <br/>
 -> Mount kennyos.img using ImDisk <br/>
 
		imdisk -a -f "kennyos.img" -m A:
		
 <br/>
 -> Copy kernel.sys to A:\ <br/>
 
		copy kernel.sys a:\kernel.sys
		
<br/>
-> Unmount kennyos.img  <br/>
 
		imdisk -d -m a:
<br/>
 -> Open MagicISO and add kennyos.img as El-Torito boot image
