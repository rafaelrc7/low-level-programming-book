.extern print_string
.extern read_word

.include "iolib.s"

.globl _start

.set pc, %r15
.set w, %r14
.set rstack, %r13

.bss
	.skip 1023*8
	rstack_start: .skip 1*8
	input_buf: .skip 1024

.text

/* program */
main_stub: .quad xt_main

/* dict */
.quad 0
.string "drop"
.byte 0
xt_drop: .quad i_drop
i_drop:
	addq	$8,	%rsp
	jmp	next

xt_init: .quad i_init
i_init:
	movq	$rstack_start,	rstack
	movq	$main_stub,	pc
	jmp	next

xt_docol: .quad i_docol
i_docol:
	subq	$8,	rstack
	movq	pc,	(rstack)
	addq	$8,	w
	movq	w,	pc
	jmp	next

xt_exit: .quad i_exit
i_exit:
	movq	(rstack),	pc
	addq	$8,		rstack
	jmp	next

xt_word: .quad i_word
i_word:
	popq	%rdi
	movq	$1024,		%rsi
	call	read_word
	pushq	%rdx
	jmp	next

xt_prints: .quad i_prints
i_prints:
	popq	%rdi
	call	print_string
	jmp	next

xt_bye: .quad i_bye
i_bye:
	movq	$60,	%rax
	xorq	%rdi,	%rdi
	syscall

xt_inbuf: .quad i_inbuf
i_inbuf:
	pushq	$input_buf
	jmp	next

xt_main: 	.quad i_docol
		.quad xt_inbuf
		.quad xt_word
		.quad xt_drop
		.quad xt_inbuf
		.quad xt_prints
		.quad xt_bye

next:
	movq	(pc),	w
	addq	$8,	pc
	jmp	(w)

_start: jmp i_init

