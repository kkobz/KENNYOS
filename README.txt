KENNYOS

What is KENNYOS?
KENNYOS is a bare-bones operating system built for Intel x86 computers.

What programming language(s) are used?
 -> Assembly (NASM x86 syntax)

What compilation tools are used to build KENNYOS?
 -> NASM
 -> MagicISO
 -> ImDisk
 
Where does the OS run from?
 -> Virtual ISO
 -> Virtual Floppy Image
 -> USB Stick
 -> Physical 3.5" 1.44MB Floppy Diskette
 -> Physical CD/DVD
 
How do I compile?
 -> Open NasmPath from Desktop and move into project directory
 ** If you don't have a NasmPath shell, visit NASM.us and download
	NASM installer

 -> Compile the BOOT.ASM file using the following command
	
		nasm -f bin -o kennyos.img BOOT.ASM
		
 -> Compile the KERNEL.SYS file using the following command
	
		nasm -f bin -o kernel.sys KERNEL.ASM
		
 -> Mount kennyos.img using ImDisk
 
		imdisk -a -f "kennyos.img" -m A:
		
 -> Copy kernel.sys to A:\
 
		copy kernel.sys a:\kernel.sys
		
 -> Unmount kennyos.img 
 
		imdisk -d -m a:

 -> Open MagicISO and add kennyos.img as El-Torito boot image
