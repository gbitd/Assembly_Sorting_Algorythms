# Alunos: Gabriel Bitdinger 118542 / Peter Mundadi 116338 / Kananda Caroline 116382
.section .data
    vetor: .space 32
    msg: .string "Digite um valor: "
    str: .string "%d|"
    msg1: .string "\nVetor ordenado\n"


.text
.globl _start

_start:

    movl $0, %ebx       # Carrega o valor 0 para ebx que sera usado como contador
    leal vetor, %edi    # Carrega o endereço do vetor em %edi
    call ler_input      # Chama função para ler input

    movl $0, %eax       # Seta o valor de eax em 0

    carregafator:       # Calcula o h; h = h * 3 enquanto h < n
        cmpl $8, %eax
        jg endfator
        addl $3, %eax
        jmp carregafator

    endfator:

    addl $1, %eax       # Adiciona um ao h

    leal vetor, %edi    # Passa para edi o endereço em memoria do vetor
    call shellSort      # Chama o ShellSort

    pushl $msg1
    call printf
    addl $4, %esp

    leal vetor, %edi    # Carrega o endereço do vetor em %edi
    call mostra_vetor   # Chama a função que exibe o vetor
    call exit


shellSort:
    
    beg:                # beg define o laço while externo do shellSort while(h > 0)

    movl $0, %edx       # Divide h por 3
    movl $3, %ebx
    div %ebx

    movl %eax, %ebx     # Define ebx como i, recebendo o valor de h

    call for            # Chama o laço for(i = h; i < n; i++)

    cmpl $1, %eax       # Verifica continuação do while h > 0
    jg beg

    ret

for:
    
    movl (%edi, %ebx, 4), %esi      # esi recebe o valor de array[i]
    movl %ebx, %ecx                 # ecx é inicializado como i; j = i
    
    while:                          # Laço while interno while(j >= h && array[j - h] > c)
        movl %ecx, %edx             # Move j para edx
        subl %eax, %edx             # Subtrai h de edx; calculando a posição j - h
        
        movl (%edi, %edx, 4), %edx  # Move para edx o valor em array[j - h]
        movl %edx, (%edi, %ecx, 4)  # array[j] = array[j - h]

        cmpl %esi, %edx             # Compara se c > array[j - h] 
        jl end

        subl %eax, %ecx             # Subtrai h de j

        cmpl %ecx, %eax             # Compara se j é maior igual a h
        jle while

    end:

    movl %esi, (%edi, %ecx, 4)      # array[j] = c
    addl $1, %ebx                   # Incrementa o i

    cmp $7, %ebx                    # Verifica se i chegou ao final do vetor
    jg return

    jmp for                         # Chama o for novamente
    
    return:

    ret

ler_input:
    pushl $msg      # Imprime a mensagem pedindo o valor
    call printf
    addl $4, %esp

    pushl %edi      # Armazena o valor digitado em edi
    pushl $str
    call scanf
    addl $8, %esp   # Limpa os argumentos da pilha após a chamada para scanf

    addl $1, %ebx   # Incrementa contador e edi
    addl $4, %edi

    cmpl $8, %ebx   # Continua o laço se o contador não for 8
    jne ler_input

    ret

mostra_vetor:
    movl $0, %ebx  # Inicializa o contador
    jmp mostra_vetor_loop

mostra_vetor_loop:
    movl (%edi, %ebx, 4), %eax  # Carrega o elemento do vetor em %eax

    pushl %eax
    pushl $str
    call printf
    addl $8, %esp         # Limpa os argumentos da pilha após a chamada para printf

    addl $1, %ebx         # Avança para o próximo elemento do vetor
    cmpl $8, %ebx
    jl mostra_vetor_loop  # Continua a iteração enquanto ebx < 8

    ret
