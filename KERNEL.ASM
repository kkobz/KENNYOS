bits 16

kernel_start:
mov ax, 2000h
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 1E00h
call kernel_cls
mov si, str_welcome
call kernel_printtxt
call kernel_println

kernel_main:
call kernel_println
call kernel_prompt

mov di, buffer
call kernel_getstring

mov si, buffer
cmp byte [si], 0
je kernel_main

mov ax, buffer
call kernel_txtup

mov si, buffer
mov di, cmd_hi
call kernel_strcmp
jc prgm_hi

mov si, buffer
mov di, cmd_ayr
call kernel_strcmp
jc prgm_ayr

mov si, buffer
mov di, cmd_help
call kernel_strcmp
jc prgm_help

mov si, buffer
mov di, cmd_clear
call kernel_strcmp
jc prgm_clear

mov si, buffer
mov di, cmd_trivia
call kernel_strcmp
jc prgm_trivia

mov si, errorcmd
call kernel_printtxt
jmp kernel_main

prgm_trivia:
call kernel_println
call kernel_println
mov si, triviatitle
call kernel_printtxt
call kernel_println
call kernel_println
mov si, question1
call kernel_printtxt
call kernel_println
call kernel_println
call kernel_prompt
mov di, buffer
call kernel_getstring
mov ax, buffer
call kernel_txtup
mov si, buffer
mov di, answer1
call kernel_strcmp
jnc .wrong
jmp .right

.right:
call kernel_println
call kernel_println
mov si, correctresp
call kernel_printtxt
call kernel_println
call kernel_println
mov si, thanktrivia
call kernel_printtxt
jmp kernel_main

.wrong:
call kernel_println
call kernel_println
mov si, incorrectresp
call kernel_printtxt
call kernel_println
call kernel_println
mov si, thanktrivia
call kernel_printtxt
jmp kernel_main

prgm_clear:
call kernel_cls
jmp kernel_main

prgm_help:
call kernel_println
call kernel_println
mov si, helptext
call kernel_printtxt
jmp kernel_main

prgm_hi:
call kernel_println
call kernel_println
mov si, helloworld
call kernel_printtxt
call kernel_println
jmp kernel_main

prgm_ayr:
call kernel_println
call kernel_println
mov si, ayr_title
call kernel_printtxt
call kernel_println
mov si, kennysays
call kernel_printtxt
call kernel_prompt
mov di, buffer
call kernel_getstring
mov ax, buffer
call kernel_txtup
mov si, buffer
mov di, hellocmp
call kernel_strcmp
jnc .rude
jmp .polite

.rude:
call kernel_println
mov si, urude
call kernel_printtxt
jmp kernel_main

.polite:
call kernel_println
mov si, upolite
call kernel_printtxt
jmp kernel_main



helloworld db " Hello World!", 0
errorcmd db "Invalid Command!", 0
incorrectresp db " Sorry. That's incorrect.", 0
correctresp db " You're Correct! Good Job!", 0
thanktrivia db " Thank you for playing!", 0
triviatitle db " KENNYOS TRIVIA!!!", 0
kennysays db " Kenny says: Hello! What do you want to say?", 0x0d, 0x0a, 0
ayr_title db " ARE YOU RUDE???", 0x0d, 0x0a, 0
cmd_hi db "HELLO", 0
cmd_ayr db "AYR", 0
cmd_help db "HELP", 0
cmd_clear db "CLEAR", 0
cmd_trivia db "TRIVIA", 0
prompt db " >> ", 0
hellocmp db "HELLO", 0
str_welcome db " KENNYOS v0.01", 0xd,0xa, " Developed by Kenneth D. Kobz", 0
newline db 0xd,0xa,0
urude db " You're rude!", 0x0d, 0x0a, 0
upolite db " You're polite!", 0x0d, 0x0a, 0
helptext db " Commands: HELLO, AYR, HELP, CLEAR, TRIVIA", 0x0d, 0x0a, 0
buffer times 64 db 0
question1 db " Question: What is Kenneth D. Kobz's favorite band?", 0
answer1 db "FLEETWOOD MAC", 0

kernel_txtup:
pusha
mov si, ax

.more:
cmp byte [si], 0
je .done
cmp byte [si], 'a'
jb .noatoz
cmp byte [si], 'z'
ja .noatoz
sub byte [si], 20h
inc si
jmp .more

.noatoz:
inc si
jmp .more

.done:
popa
ret

kernel_getstring:
xor cl, cl

.loop:
mov ah, 0
int 0x16   
cmp al, 0x08
je .backspace
cmp al, 0x0D
je .done
cmp cl, 0x3F
je .loop
mov ah, 0x0E
int 0x10
stosb
inc cl
jmp .loop
 
.backspace:
cmp cl, 0
je .loop
 
dec di
mov byte [di], 0
dec cl
mov ah, 0x0E
mov al, 0x08
int 10h
mov al, ' '
int 10h
mov al, 0x08
int 10h
jmp .loop
 
 .done:
mov al, 0
stosb
mov ah, 0x0E
mov al, 0x0D
int 0x10
mov al, 0x0A
int 0x10
ret

kernel_strcmp:

.loop:
mov al, [si]
mov bl, [di]
cmp al, bl
jne .notequal
cmp al, 0
je .done
inc di
inc si
jmp .loop
 
.notequal:
clc
ret
 
.done:         
stc
ret

kernel_prompt:
mov si, prompt
call kernel_printtxt
ret

kernel_println:
mov si, newline
call kernel_printtxt
ret

kernel_printtxt:
mov ah, 0eh
lodsb
cmp al, 0
je .done
int 10h
jmp kernel_printtxt

.done:
ret

kernel_cls:
mov ah, 2
mov bh, 0
mov dh, 0
mov dl, 0
int 10h
mov ah, 9
mov al, ' '
mov bh, 0
mov bl, 00000111b
mov cx, 2000
int 10h
ret
