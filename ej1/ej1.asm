; /** defines bool y puntero **/
%define NULL 0
%define TRUE 1
%define FALSE 0

section .data

section .text

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm

; FUNCIONES auxiliares que pueden llegar a necesitar:
extern malloc
extern free
extern str_concat


string_proc_list_create:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     edi, 16
        call    malloc
        mov     QWORD  [rbp-8], rax
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], 0
        mov     rax, QWORD  [rbp-8]
        leave
        ret
string_proc_node_create:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     eax, edi
        mov     QWORD  [rbp-32], rsi
        mov     BYTE  [rbp-20], al
        mov     edi, 32
        call    malloc
        mov     QWORD  [rbp-8], rax
        mov     rax, QWORD  [rbp-8]
        movzx   edx, BYTE  [rbp-20]
        mov     BYTE  [rax+16], dl
        mov     rax, QWORD  [rbp-8]
        mov     rdx, QWORD  [rbp-32]
        mov     QWORD  [rax+24], rdx
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], 0
        mov     rax, QWORD  [rbp-8]
        leave
        ret
string_proc_list_add_node:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     QWORD  [rbp-24], rdi
        mov     eax, esi
        mov     QWORD  [rbp-40], rdx
        mov     BYTE  [rbp-28], al
        movzx   eax, BYTE  [rbp-28]
        mov     rdx, QWORD  [rbp-40]
        mov     rsi, rdx
        mov     edi, eax
        call    string_proc_node_create
        mov     QWORD  [rbp-8], rax
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        test    rax, rax
        jne     .L6
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax], rdx
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax+8], rdx
        jmp     .L8
.L6:
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax+8]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax], rdx
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rax+8]
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], rdx
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax+8], rdx
.L8:
        nop
        leave
        ret
.LC0:
        .string ""
string_proc_list_concat:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 64
        mov     QWORD  [rbp-40], rdi
        mov     eax, esi
        mov     QWORD  [rbp-56], rdx
        mov     BYTE  [rbp-44], al
        mov     rax, QWORD  [rbp-56]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:.LC0
        call    str_concat
        mov     QWORD  [rbp-8], rax
        mov     rax, QWORD  [rbp-40]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        jmp     .L10
.L12:
        mov     rax, QWORD  [rbp-16]
        movzx   eax, BYTE  [rax+16]
        cmp     BYTE  [rbp-44], al
        jne     .L11
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rbp-24], rax
        mov     rax, QWORD  [rbp-16]
        mov     rdx, QWORD  [rax+24]
        mov     rax, QWORD  [rbp-8]
        mov     rsi, rdx
        mov     rdi, rax
        call    str_concat
        mov     QWORD  [rbp-8], rax
        mov     rax, QWORD  [rbp-24]
        mov     rdi, rax
        call    free
.L11:
        mov     rax, QWORD  [rbp-16]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
.L10:
        cmp     QWORD  [rbp-16], 0
        jne     .L12
        mov     rax, QWORD  [rbp-8]
        leave
        ret
string_proc_list_destroy:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD  [rbp-24], rdi
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-8], rax
        mov     QWORD  [rbp-16], 0
        jmp     .L15
.L16:
        mov     rax, QWORD  [rbp-8]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        mov     rax, QWORD  [rbp-8]
        mov     rdi, rax
        call    string_proc_node_destroy
        mov     rax, QWORD  [rbp-16]
        mov     QWORD  [rbp-8], rax
.L15:
        cmp     QWORD  [rbp-8], 0
        jne     .L16
        mov     rax, QWORD  [rbp-24]
        mov     QWORD  [rax], 0
        mov     rax, QWORD  [rbp-24]
        mov     QWORD  [rax+8], 0
        mov     rax, QWORD  [rbp-24]
        mov     rdi, rax
        call    free
        nop
        leave
        ret
string_proc_node_destroy:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     QWORD  [rbp-8], rdi
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+24], 0
        mov     rax, QWORD  [rbp-8]
        mov     BYTE  [rax+16], 0
        mov     rax, QWORD  [rbp-8]
        mov     rdi, rax
        call    free
        nop
        leave
        ret
str_concat:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     QWORD  [rbp-40], rdi
        mov     QWORD  [rbp-48], rsi
        mov     rax, QWORD  [rbp-40]
        mov     rdi, rax
        call    strlen
        mov     DWORD  [rbp-4], eax
        mov     rax, QWORD  [rbp-48]
        mov     rdi, rax
        call    strlen
        mov     DWORD  [rbp-8], eax
        mov     edx, DWORD  [rbp-4]
        mov     eax, DWORD  [rbp-8]
        add     eax, edx
        mov     DWORD  [rbp-12], eax
        mov     eax, DWORD  [rbp-12]
        add     eax, 1
        cdqe
        mov     rdi, rax
        call    malloc
        mov     QWORD  [rbp-24], rax
        mov     rdx, QWORD  [rbp-40]
        mov     rax, QWORD  [rbp-24]
        mov     rsi, rdx
        mov     rdi, rax
        call    strcpy
        mov     rdx, QWORD  [rbp-48]
        mov     rax, QWORD  [rbp-24]
        mov     rsi, rdx
        mov     rdi, rax
        call    strcat
        mov     rax, QWORD  [rbp-24]
        leave
        ret
.LC1:
        .string "List length: %d\n"
.LC2:
        .string "\tnode hash: %s | type: %d\n"
string_proc_list_print:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD  [rbp-24], rdi
        mov     QWORD  [rbp-32], rsi
        mov     DWORD  [rbp-4], 0
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        jmp     .L21
.L22:
        add     DWORD  [rbp-4], 1
        mov     rax, QWORD  [rbp-16]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
.L21:
        cmp     QWORD  [rbp-16], 0
        jne     .L22
        mov     edx, DWORD  [rbp-4]
        mov     rax, QWORD  [rbp-32]
        mov     esi, OFFSET FLAT:.LC1
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        jmp     .L23
.L24:
        mov     rax, QWORD  [rbp-16]
        movzx   eax, BYTE  [rax+16]
        movzx   ecx, al
        mov     rax, QWORD  [rbp-16]
        mov     rdx, QWORD  [rax+24]
        mov     rax, QWORD  [rbp-32]
        mov     esi, OFFSET FLAT:.LC2
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        mov     rax, QWORD  [rbp-16]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
.L23:
        cmp     QWORD  [rbp-16], 0
        jne     .L24
        nop
        nop
        leave
        ret

