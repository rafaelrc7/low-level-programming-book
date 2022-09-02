.extern exit
.extern read_word
.extern parse_int
.extern string_length
.extern find_word
.extern print_string
.extern print_err

.include "words.inc"

.set	pc,	%r12
.set	w,	%r13
.set	rstack,	%r14
.set	dstack,	%rbx

.macro rstack_push val:req
movq	\val,	(rstack)
subq	$8,	rstack
.endm

.macro rstack_pop val:req
addq	$8,		rstack
movq	(rstack),	\val
.endm

.macro dstack_push val:req
movq	\val,	(dstack)
subq	$8,	dstack
.endm

.macro dstack_pop val:req
addq	$8,		dstack
movq	(dstack),	\val
.endm

.section .rodata
err_unk_word: .string	"[ERROR]: unknown word."

.bss
.skip 1023*8
rstack_base:	.skip 1*8

.skip 1023*8
dstack_base:	.skip 1*8

mem:		.skip 65536*8
input_buff:	.skip 255

.data
program_stub:	.skip 8
xt_interpreter:	.quad	interpreter
interpreter:	.quad	interpreter_loop

.text

.globl _start
_start:
	call	interpreter_init
	movq	%rax,		%rdi
	call	exit

next:
	movq	(pc),	w
	addq	$8,	pc
	jmp	(w)

interpreter_init:
	pushq	%rbp
	movq	%rsp,		%rbp
	subq	$48,		%rsp

	movq	%r12,		-8(%rbp)
	movq	%r13,		-16(%rbp)
	movq	%r14,		-24(%rbp)
	movq	%r15,		-32(%rbp)
	movq	%rbx,		-40(%rbp)

	movq	rstack_base,	rstack
	movq	dstack_base,	dstack

interpreter_loop:

	movq	$input_buff,	%rdi
	movq	$255,		%rsi
	call	read_word

	testq	%rax,		%rax
	jz	2f

	movb	(%rax),		%al
	testb	%al,		%al
	jz	1f

	movq	$input_buff,	%rdi
	call	string_length
	movq	%rax,	%r15

	movq	$input_buff,	%rdi
	call	parse_int

	testq	%rdx,		%rdx
	jz	parse_word_in

	cmpq	%rdx,		%r15
	jne	parse_word_in



	dstack_push	%rax
	jmp interpreter_loop

	parse_word_in:
	movq	$input_buff,	%rdi
	movq	$last_node,	%rsi
	call	find_word

	testq	%rax,		%rax
	jz	4f

	movq	%rax,		%rdi
	call	cfa

	movq	%rax,		program_stub
	movq	$program_stub,	pc
	jmp next

	1:
	xorq	%rax,		%rax
	jmp	3f

	4:
	movq	$err_unk_word,	%rdi
	call	print_err
	jmp	interpreter_loop

	2:
	movq	$1,		%rax

	3:
	movq	-8(%rbp),		%r12
	movq	-16(%rbp),		%r13
	movq	-24(%rbp),		%r14
	movq	-32(%rbp),		%r15
	movq	-40(%rbp),		%rbx

	leave
	ret

