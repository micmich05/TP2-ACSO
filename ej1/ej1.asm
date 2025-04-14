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
    mov     edi, 16       ; solicitar 16 bytes
    call    malloc
    mov     QWORD [rbp-8], rax
    ; Inicializar lista: (head, tail) = (0,0)
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
    mov     eax, edi            ; carácter en al
    mov     QWORD [rbp-32], rsi  ; guardar puntero a la cadena
    mov     BYTE [rbp-20], al    ; almacenar carácter
    mov     edi, 32             ; solicitar 32 bytes para el nodo
    call    malloc
    mov     QWORD [rbp-8], rax   ; puntero al nodo
    ; Establece el carácter en offset 16
    mov     rax, QWORD [rbp-8]
    movzx   edx, BYTE [rbp-20]
    mov     BYTE [rax+16], dl
    ; Establece el puntero a la cadena en offset 24
    mov     rax, QWORD [rbp-8]
    mov     rdx, QWORD [rbp-32]
    mov     QWORD [rax+24], rdx
    ; Inicializa los punteros internos del nodo a 0
    mov     rax, QWORD [rbp-8]
    mov     QWORD [rax], 0
    mov     rax, QWORD [rbp-8]
    mov     QWORD [rax+8], 0
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
    mov     BYTE [rbp-28], al       ; carácter a almacenar
    movzx   eax, BYTE [rbp-28]
    mov     rdx, QWORD [rbp-40]
    mov     rsi, rdx
    mov     edi, eax
    call    string_proc_node_create_asm
    mov     QWORD [rbp-8], rax       ; puntero al nuevo nodo

    ; Verifica si la lista está vacía (si head == 0)
    mov     rax, QWORD [rbp-24]
    mov     rax, QWORD [rax]         ; obtiene la cabeza de la lista
    test    rax, rax
    jne     .L_update_existing       ; si no es cero, la lista ya tiene elementos

    ; Rama: lista vacía
    mov     rax, QWORD [rbp-24]
    mov     rdx, QWORD [rbp-8]
    mov     QWORD [rax], rdx         ; head = nuevo nodo
    mov     rax, QWORD [rbp-24]
    mov     rdx, QWORD [rbp-8]
    mov     QWORD [rax+8], rdx       ; tail = nuevo nodo
    mov     rsp, rbp
    pop     rbp
    ret

.L_update_existing:
    ; Rama: lista no vacía
    ; Enlaza el nuevo nodo al final de la lista:
    mov     rax, QWORD [rbp-24]
    mov     rax, QWORD [rax+8]       ; obtiene el tail actual
    mov     rdx, QWORD [rbp-8]       ; nuevo nodo
    mov     QWORD [rax], rdx         ; tail->next = nuevo nodo
    ; Actualiza el tail de la lista al nuevo nodo:
    mov     rax, QWORD [rbp-24]
    mov     rdx, QWORD [rbp-8]
    mov     QWORD [rax+8], rdx
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
    mov     BYTE [rbp-44], al       ; carácter de comparación

    ; Inicializa el acumulador llamando a str_concat(empty_string, main_string)
    mov     rax, QWORD [rbp-56]
    mov     rsi, rax
    mov     rdi, empty_string
    call    str_concat
    mov     QWORD [rbp-8], rax       ; acumulador de la concatenación

    ; Obtiene la cabeza de la lista en [rbp-16]
    mov     rax, QWORD [rbp-40]
    mov     rax, QWORD [rax]         ; head de la lista
    mov     QWORD [rbp-16], rax

.loop_start:
    mov     rax, QWORD [rbp-16]
    cmp     rax, 0
    je      .loop_end

    ; Extrae el carácter del nodo actual (offset +16)
    mov     rax, QWORD [rbp-16]
    movzx   eax, BYTE [rax+16]
    cmp     BYTE [rbp-44], al
    jne     .node_skip           ; si no coincide, se salta el procesamiento

    ; Si coincide, concatena la cadena almacenada (offset +24) al acumulador:
    mov     rax, QWORD [rbp-8]
    mov     QWORD [rbp-24], rax   ; almacena temporalmente el acumulador actual
    mov     rax, QWORD [rbp-16]
    mov     rdx, QWORD [rax+24]   ; obtiene el puntero a la cadena del nodo
    mov     rax, QWORD [rbp-8]
    mov     rsi, rdx
    mov     rdi, rax
    call    str_concat           ; acumula la cadena del nodo
    mov     QWORD [rbp-8], rax   ; actualiza el acumulador
    mov     rax, QWORD [rbp-24]
    mov     rdi, rax
    call    free                ; libera el acumulador anterior

.node_skip:
    ; Avanza al siguiente nodo
    mov     rax, QWORD [rbp-16]
    mov     rax, QWORD [rax]      ; siguiente nodo
    mov     QWORD [rbp-16], rax
    jmp     .loop_start

.loop_end:
    mov     rax, QWORD [rbp-8]    ; resultado final
    mov     rsp, rbp
    pop     rbp
    ret
