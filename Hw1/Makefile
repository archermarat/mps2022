all: matr

main.o:	matr.asm
	nasm -f elf matr.asm

matr:	main.o
	ld -m elf_i386 matr.o -o matr
	rm matr.o
