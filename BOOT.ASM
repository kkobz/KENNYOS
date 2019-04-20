bits 16
jmp short bootloader_start
nop              

db "        "
dw 512
db 1  
dw 1
db 2  
dw 224
dw 2880
db 0F0h
dw 9
dw 18
dw 2
dd 0
dd 0
dw 0
db 41
dd 0
db "KENNYOS    "
db "FAT12   "

bootloader_start:
mov ax, 07C0h                   
mov ds, ax
cli
mov sp, 7A00h
sti
mov [bootdev], dl
mov si, start_msg
call print_string
mov ah, 8        
mov dl, byte [bootdev]
int 13h
jc fatal_disk_error
and cx, 3Fh                     
mov [SectorsPerTrack], cx
movzx dx, dh                    
add dx, 1                 
mov [Sides], dx

floppy_ok:
mov ax, 19
call l2hts
mov si, buffer
mov bx, ds
mov es, bx
mov bx, si

read_root_dir:
mov ah, 2
mov al, 14
int 13h   
jnc search_dir
call reset_floppy 
jnc read_root_dir
jmp fatal_disk_error

search_dir:
mov ax, ds
mov es, ax
mov di, buffer
mov cx, 224
mov ax, 0

next_root_entry:
xchg cx, dx
mov si, kern_filename
mov cx, 11
rep cmpsb
je found_file_to_load
add ax, 32   
mov di, buffer
add di, ax
xchg dx, cx
loop next_root_entry
jmp fatal_disk_error

found_file_to_load:
mov ax, word [es:di+0Fh]
mov word [cluster], ax
mov ax, 1               
call l2hts
mov di, buffer
mov bx, di

read_fat:
mov ah, 2        
mov al, 9        
int 13h          
jnc read_fat_ok  
call reset_floppy
jnc read_fat

fatal_disk_error:
mov ah, 2
mov bh, 0
mov dl, 0
mov dh, 0
int 10h
mov ah, 9
mov al, ' '
mov bh, 0
mov bl, 00000111b
mov cx, 2000
int 10h
mov si, disk_error
call print_string
jmp reboot

read_fat_ok:
mov ax, 2000h
mov es, ax
mov bx, 0

load_file_sector:
mov ax, word [cluster]
add ax, 31
call l2hts
mov ax, 2000h
mov es, ax
mov bx, word [pointer]
mov ah, 2
mov al, 1
int 13h
jnc calculate_next_cluster
call reset_floppy   
jmp load_file_sector

calculate_next_cluster:
mov ax, [cluster]
mov dx, 0
mov bx, 3
mul bx
mov bx, 2
div bx
mov si, buffer
add si, ax       
mov ax, word [ds:si]
or dx, dx                      
jz even

odd:
shr ax, 4      
jmp short next_cluster_cont


even:
and ax, 0FFFh

next_cluster_cont:
mov word [cluster], ax
cmp ax, 0FF8h    
jae end
add word [pointer], 512
jmp load_file_sector

end:  
mov dl, byte [bootdev]
jmp 2000h:0000h

reboot:
mov ax, 0
int 16h  
mov ax, 0
int 19h 

print_string:   
mov ah, 0Eh
lodsb
cmp al, 0
je .done       
int 10h          
jmp print_string

.done:
ret

reset_floppy:   
mov ah, 0
mov dl, byte [bootdev]
int 13h
ret

l2hts:
push ax
mov dx, 0                       
div word [SectorsPerTrack]
add dl, 01h                    
mov cl, dl                     
pop ax
mov dx, 0           
div word [SectorsPerTrack]
mov dx, 0
div word [Sides]
mov dh, dl  
mov ch, al
mov dl, byte [bootdev] 
ret

kern_filename db "KERNEL  SYS", 0
disk_error db "Disk error has occured! Press any key...", 0
start_msg db "Starting KENNYOS...", 0xd, 0xa, 0xd, 0xa, 0
SectorsPerTrack dw 0
Sides dw 0
bootdev db 0
cluster dw 0
pointer dw 0

times 510-($-$$) db 0   
dw 0AA55h               

buffer:
times 1474560-($-$$) db 0
