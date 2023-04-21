    section .text

    global _start

    _start:

    ;
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov edx, nllen
    mov ecx, nlmsg
    mov ebx, 1
    mov eax, 4
    int 0x80
    ;
    call _get_str
    mov esi, buff
    ;Читаем размер матрицы
    call _skip_spaces
    cmp eax, 0
    jne er1
    call _get_int
    mov [n], eax
	cmp eax, 3
	jb er1
	cmp eax, 10
	ja er1
	    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov edx, nllen
    mov ecx, nlmsg
    mov ebx, 1
    mov eax, 4
    int 0x80
    
    mov ecx, [n]
    s1:
    mov [c1], ecx
    call _get_str
    mov esi, buff
    mov ecx, [n]
    s2:
    mov [c2], ecx
    call _skip_spaces
    cmp eax, 0
    jne er1
    call _get_int
    push eax
	;call _out_int
 
    mov ecx, [c2]
    loop s2

    mov ecx, [c1]
    loop s1

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov edx, nllen
    mov ecx, nlmsg
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov ecx, [n]
    mov eax, [n]
    mul eax
    sub eax, 1
    mov esi, eax

    s3:
    mov [c1], ecx
    mov eax, [esp + 4*esi]
	
    sub esi, 2
    mov ebx, [esp+ 4*esi]
    sub eax, ebx
    call _out_int

    mov edx, nllen
    mov ecx, nlmsg
    mov ebx, 1
    mov eax, 4
    int 0x80
	
    add esi, 2
    sub esi, [n]

    mov ecx, [c1]
    loop s3

    jmp end
    er1:
    mov eax, 4
    mov ebx, 1
    mov ecx, errmsg1
    mov edx, errlen1
    int 0x80
	mov edx, nllen
    mov ecx, nlmsg
    mov ebx, 1
    mov eax, 4
    int 0x80

    end:
    mov eax, 1
    int 0x80
    ;-------------------------------------------—
    _skip_spaces:
    mov ecx, eax
    ss1:
    mov al, [esi]
    cmp al, ' '
    jne ss2

    inc esi
    jmp ss1

    ss2:
    cmp al,'-'
    jne ss3
    inc esi
    mov al, [esi]
    dec esi
    ss3:
    cmp al,'0' ; если введен неверный символ <0
    jb sserr
    cmp al,'9' ; если введен неверный символ >9
    ja sserr

    mov eax,0
    ret
    sserr:
    mov eax, 1
    ret

    ;-------------------------------------------—
    _get_str:
    mov eax, 3
    mov ebx, 0
    mov ecx, buff
    mov edx, 59
    int 80h
    mov bl, 0
    mov byte [buff+eax], bl
    ret

    ;-------------------------------------------—
    _get_int:
	mov edi, 0
    mov al, [esi]
    cmp al,"-" ; если первый символ минус
    jnz gi1
    mov edi,1 ; устанавливаем флаг
    inc esi ; и пропускаем его
    gi1:
    xor eax,eax
    mov ebx, 10 ; основание сc
    gi2:
    mov ecx,0
    mov cl,[esi] ; берем символ из буфера

    cmp cl,'0' ; если введен неверный символ <0
    jb gi3
    cmp cl,'9' ; если введен неверный символ >9
    ja gi3

    sub cl,'0' ; делаем из символа число
    mul ebx ; умножаем на 10
    add eax,ecx ; прибавляем к остальным
    inc esi ; указатель на следующий символ
    jmp gi2 ; повторяем
    gi3:
    cmp edi,1 ; если установлен флаг, то
    jnz gi4
    neg eax ; делаем число отрицательным
    gi4:
    ret
    ;-------------------------------------------—
    _out_int:
    ; Проверяем число на знак.
    test eax, eax
    jns oi1
    ; Если оно отрицательное, выведем минус и оставим его модуль.
    push eax
    mov al, '-'
    mov [char], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char
    mov edx, 1
    int 0x80
    pop eax
    neg eax
    ; Количество цифр будем держать в CX.
    oi1:
    xor ecx, ecx
    mov ebx, 10 ; основание сс. 10 для десятеричной и т.п.
    oi2:
    xor edx,edx
    div ebx
    ; Делим число на основание сс. В остатке получается последняя цифра.
    ; Сразу выводить её нельзя, поэтому сохраним её в стэке.
    push edx
    inc ecx
    ; А с частным повторяем то же самое, отделяя от него очередную
    ; цифру справа, пока не останется ноль, что значит, что дальше
    ; слева только нули.
    test eax, eax
    jnz oi2
    ; Теперь приступим к выводу.
    mov ebx, 1
    mov edx, 1
    oi3:
    pop eax,
    add al, '0'
    mov [char], al
    push ecx
    mov ecx, char
    mov eax, 4
    int 0x80
    pop ecx
    ; Повторим ровно столько раз, сколько цифр насчитали.
    loop oi3
    ret

    section .data
    nlmsg db 0xA, 0xD
    nllen equ $-nlmsg
    msg1 db "Input n ( 3 <= n <= 10):"
    len1 equ $ - msg1
    msg2 db "Input matrix:"
    len2 equ $ - msg2
    msg3 db "Total vector:"
    len3 equ $ - msg3
    errmsg1 db "Input error"
    errlen1 equ $ - errmsg1

    segment .bss
    char resb 1
    n resd 1
    c1 resd 1
    c2 resd 1
    buff resb 60


