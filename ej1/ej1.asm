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
        mov     QWORD [rbp-24], rdi      ; puntero a la lista
        mov     eax, esi
        mov     QWORD [rbp-40], rdx      ; puntero a la cadena
        mov     BYTE [rbp-28], al       ; carácter a asignar
        movzx   eax, BYTE [rbp-28]
        mov     rdx, QWORD [rbp-40]
        mov     rsi, rdx
        mov     edi, eax
        call    string_proc_node_create_asm
        mov     QWORD [rbp-8], rax      ; nuevo nodo creado
        mov     rax, QWORD [rbp-24]
        mov     rax, QWORD [rax]        ; cabeza de la lista
        test    rax, rax
        jne     update_existing_list    ; si la lista no está vacía, maneja lista existente

        ; Caso lista vacía: inicializa cabeza y cola con el nuevo nodo
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax], rdx
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax+8], rdx
        jmp     finish_add_node

update_existing_list:
        ; La lista no está vacía, se actualiza el siguiente de la cola
        mov     rax, QWORD [rbp-24]
        mov     rax, QWORD [rax+8]      ; obtiene la cola actual
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax], rdx
        ; Actualiza la dirección de la nueva cola en la lista
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rax+8]
        mov     rax, QWORD [rbp-8]
        mov     QWORD [rax+8], rdx
        mov     rax, QWORD [rbp-24]
        mov     rdx, QWORD [rbp-8]
        mov     QWORD [rax+8], rdx

finish_add_node:
        nop
        mov     rsp, rbp
        pop     rbp
        ret

string_proc_list_concat_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 64
        mov     QWORD [rbp-40], rdi      ; puntero a la lista
        mov     eax, esi
        mov     QWORD [rbp-56], rdx      ; puntero a la cadena principal
        mov     BYTE [rbp-44], al       ; carácter a comparar
        mov     rax, QWORD [rbp-56]
        mov     rsi, rax
        ; Usa la cadena vacía definida en .data
        mov     rdi, empty_string
        call    str_concat
        mov     QWORD [rbp-8], rax       ; resultado acumulado de la concatenación
        mov     rax, QWORD [rbp-40]
        mov     rax, QWORD [rax]         ; inicio de la lista
        mov     QWORD [rbp-16], rax

concat_loop_check:
        cmp     QWORD [rbp-16], 0
        jne     concat_process_node    ; si aún quedan nodos, procesa el nodo actual
        mov     rax, QWORD [rbp-8]
        mov     rsp, rbp
        pop     rbp
        ret

concat_process_node:
        ; Procesa el nodo actual. Se compara el carácter almacenado en el nodo con el carácter de comparación.
        mov     rax, QWORD [rbp-16]
        movzx   eax, BYTE [rax+16]
        cmp     BYTE [rbp-44], al
        jne     concat_advance_node    ; si no coincide, salta a avanzar al siguiente nodo
        mov     rax, QWORD [rbp-8]
        mov     QWORD [rbp-24], rax      ; guarda temporalmente el string acumulado
        mov     rax, QWORD [rbp-16]
        mov     rdx, QWORD [rax+24]      ; obtiene el string del nodo
        mov     rax, QWORD [rbp-8]
        mov     rsi, rdx
        mov     rdi, rax
        call    str_concat             ; concatena el string del nodo al acumulado
        mov     QWORD [rbp-8], rax       ; actualiza el acumulado
        mov     rax, QWORD [rbp-24]
        mov     rdi, rax
        call    free                   ; libera la memoria del string anterior

concat_advance_node:
        ; Avanza al siguiente nodo de la lista
        mov     rax, QWORD [rbp-16]
        mov     rax, QWORD [rax]
        mov     QWORD [rbp-16], rax
        jmp     concat_loop_check