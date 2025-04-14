%define NULL 0
%define TRUE 1
%define FALSE 0

section .data
empty_string: db 0

section .text

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm

extern malloc
extern free
extern str_concat

string_proc_list_create_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     edi, 16
        call    malloc
        mov     QWORD [rbp-8], rax
        mov     rax, QWORD [rbp-8]
        mov     QWORD [rax], 0
        mov     rax, QWORD [rbp-8]
        mov     QWORD [rax+8], 0
        mov     rsp, rbp
        pop     rbp
        ret

string_proc_node_create_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     eax, edi
        mov     QWORD [rbp-32], rsi
        mov     BYTE [rbp-20], al
        mov     edi, 32
        call    malloc
        mov     QWORD [rbp-8], rax
        mov     rax, QWORD [rbp-8]
        movzx   edx, BYTE [rbp-20]
        mov     BYTE [rax+16], dl
        mov     rax, QWORD [rbp-8]
        mov     rdx, QWORD [rbp-32]
        mov     QWORD [rax+24], rdx
        mov     rax, QWORD [rbp-8]
        mov     QWORD [rax], 0
        mov     rax, QWORD [rbp-8]
        mov     QWORD [rax+8], 0
        mov     rax, QWORD [rbp-8]
        mov     rsp, rbp
        pop     rbp
        ret

string_proc_list_add_node_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     QWORD [rbp-24], rdi      
        mov     eax, esi
        mov     QWORD [rbp-40], rdx      
        mov     BYTE [rbp-28], al       
        movzx   eax, BYTE [rbp-28]
        mov     rdx, QWORD [rbp-40]
        mov     rsi, rdx
        mov     edi, eax
        call    string_proc_node_create_asm
        mov     QWORD [rbp-8], rax      
        mov     rax, QWORD [rbp-24]
        mov     rax, QWORD [rax]        
        test    rax, rax
        jne     update_existing_list    ;si la lista no está vacía, maneja lista existente

        ;caso lista vacía: inicializa head y tail con el nuevo nodo
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax], rdx
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax+8], rdx
        mov     rsp, rbp
        pop     rbp
        ret

update_existing_list:
        ;la lista no está vacía -> se actualiza el siguiente de la cola
        mov     rax, QWORD [rbp-24]
        mov     rax, QWORD [rax+8]      ; obtiene la cola actual
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax], rdx
        ;actualizar la dirección de la nueva cola en la lista
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rax+8]
        mov     rax, QWORD [rbp-8]
        mov     QWORD [rax+8], rdx
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax+8], rdx

string_proc_list_concat_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 64
        mov     QWORD [rbp-40], rdi      
        mov     eax, esi
        mov     QWORD [rbp-56], rdx      
        mov     BYTE [rbp-44], al       
        mov     rax, QWORD [rbp-56]
        mov     rsi, rax
        ;piso rdi con cadena vacía definida antes
        mov     rdi, empty_string
        call    str_concat
        mov     QWORD [rbp-8], rax       
        mov     rax, QWORD [rbp-40]
        mov     rax, QWORD [rax]         
        mov     QWORD [rbp-16], rax
        