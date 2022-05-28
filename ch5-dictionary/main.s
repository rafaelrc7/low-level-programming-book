.extern find_word
.extern print_string
.extern print_newline
.extern read_line
.extern exit

.section .rodata
err: .string "ERROR: key not found!\n"

.include "words.inc"

.text
.global _start
_start:
	pushq	%rbp
	movq	%rsp,		%rbp
	subq	$256,		%rbp

	leaq	-255(%rbp),	%rdi
	movq	$255,		%rsi
	call	read_line

	leaq	-255(%rbp),	%rdi
	movq	$last_node,	%rsi
	call	find_word

	testq	%rax,		%rax
	jz	1f

	movq	%rax,		%rdi
	call	print_string
	call	print_newline
	xorq	%rdi,	%rdi
	jmp	2f

	1:
	movq	$err,		%rdi
	call	print_err
	movq	$1,	%rdi

	2:
	leave
	call	exit

