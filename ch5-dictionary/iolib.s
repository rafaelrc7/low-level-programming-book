.text

.globl exit
exit:
	movq	$60,	%rax
	syscall
	ret

.globl string_length
string_length:
	xorq	%rax,	%rax

	1:
	cmpb	$0,	(%rdi)
	je	2f
	incq	%rax
	incq	%rdi
	jmp	1b

	2:
	ret

.globl print_string
print_string:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$16,	%rsp

	movq	%rdi,	-8(%rbp)
	call	string_length
	movq	-8(%rbp),	%rdi

	movq	%rax,	%rdx
	movq	%rdi,	%rsi
	movq	$1,	%rdi

	movq	$1,	%rax
	syscall

	leave
	ret

.globl print_err
print_err:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$16,	%rsp

	movq	%rdi,	-8(%rbp)
	call	string_length
	movq	-8(%rbp),	%rdi

	movq	%rax,	%rdx
	movq	%rdi,	%rsi
	movq	$2,	%rdi

	movq	$1,	%rax
	syscall

	leave
	ret

.globl print_char
print_char:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$16,	%rsp

	movb	%dil,	(%rsp)

	movq	$1,	%rax
	movq	$1,	%rdi
	movq	%rsp,	%rsi
	movq	$1,	%rdx
	syscall

	leave
	ret

.globl print_newline
print_newline:
	movq	$0xA,	%rdi
	jmp print_char

.globl print_uint
print_uint:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$32,	%rsp

	movq	$31,	%rcx
	movq	$10,	%r10

	movq	%rdi,	%rax

	1:
	xorq	%rdx,	%rdx
	divq	%r10
	addq	$0x30,	%rdx
	movb	%dl,	(%rsp, %rcx)

	decq	%rcx

	testq	%rax,	%rax
	jnz	1b

	movq	$1,	%rax
	movq	$1,	%rdi
	leaq	1(%rsp, %rcx),	%rsi
	movq	$31,	%rdx
	subq	%rcx,	%rdx
	syscall

	leave
	ret

.globl print_int
print_int:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$16,	%rsp

	cmpq	$0,	%rdi
	jge	1f

	movq	%rdi,	-8(%rbp)
	movq	$'-',	%rdi
	call	print_char
	movq	-8(%rbp),	%rdi
	negq	%rdi

	1:
	leave
	jmp	print_uint

.globl read_char
read_char:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$16,	%rsp

	xorq	%rdi,	%rdi
	movq	%rsp,	%rsi
	movq	$1,	%rdx

	xorq	%rax,	%rax
	syscall

	testq	%rax,	%rax
	jz	1f

	movq	(%rsp),	%rax

	1:
	leave
	ret

.globl read_word
read_word:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$32,	%rsp

	movq	%rbx,	-8(%rbp)
	movq	%r12,	-16(%rbp)
	movq	%r13,	-24(%rbp)

	movq	%rdi,	%rbx
	movq	%rsi,	%r12
	xorq	%r13,	%r13

	decq	%r12

	1:
	call	read_char

	cmpq	$' ',	%rax
	je	1b
	cmpq	$'\t',	%rax
	je	1b
	cmpq	$'\r',	%rax
	je	1b
	cmpq	$'\n',	%rax
	je	1b
	cmpq	$0,	%rax
	je	3f

	2:
	cmpq	%r12,	%r13
	jge	5f

	movq	%rax,	(%rbx, %r13)
	incq	%r13

	call	read_char
	cmpq	$' ',	%rax
	je	3f
	cmpq	$'\t',	%rax
	je	3f
	cmpq	$'\r',	%rax
	je	3f
	cmpq	$'\n',	%rax
	je	3f
	cmpq	$0,	%rax
	je	3f

	jmp	2b

	3:
	xorq	%r12,	%r12
	movq	%r12,	(%rbx, %r13)
	movq	%rbx,	%rax

	4:
	movq	-8(%rbp),	%rbx
	movq	-16(%rbp),	%r12
	movq	-24(%rbp),	%r13

	leave
	ret

	5:
	xorq	%rax,	%rax
	jmp	4b

.globl read_line
read_line:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$32,	%rsp

	movq	%rbx,	-8(%rbp)
	movq	%r12,	-16(%rbp)
	movq	%r13,	-24(%rbp)

	movq	%rdi,	%rbx
	movq	%rsi,	%r12
	xorq	%r13,	%r13

	decq	%r12

	1:
	call	read_char

	cmpq	$' ',	%rax
	je	1b
	cmpq	$'\t',	%rax
	je	1b
	cmpq	$'\r',	%rax
	je	1b
	cmpq	$'\n',	%rax
	je	1b
	cmpq	$0,	%rax
	je	3f

	2:
	cmpq	%r12,	%r13
	jge	5f

	movq	%rax,	(%rbx, %r13)
	incq	%r13

	call	read_char
	cmpq	$'\n',	%rax
	je	3f
	cmpq	$0,	%rax
	je	3f

	jmp	2b

	3:
	xorq	%r12,	%r12
	movq	%r12,	(%rbx, %r13)
	movq	%rbx,	%rax

	4:
	movq	-8(%rbp),	%rbx
	movq	-16(%rbp),	%r12
	movq	-24(%rbp),	%r13

	leave
	ret

	5:
	xorq	%rax,	%rax
	jmp	4b

.globl parse_uint
parse_uint:
	xorq	%rax,	%rax
	xorq	%rcx,	%rcx
	movq	$10,	%r10

	1:
	xorq	%r12,	%r12
	movb	(%rdi),	%r12b
	testq	%r12,	%r12
	jz	2f

	subq	$0x30,	%r12
	cmpq	$0,	%r12
	jl	2f
	cmpq	$9,	%r12
	jg	2f

	incq	%rcx
	mulq	%r10
	addq	%r12,	%rax

	incq	%rdi

	jmp	1b

	2:
	movq	%rcx,	%rdx
	ret

.globl parse_int
parse_int:
	pushq	%rbp
	movq	%rsp,	%rbp
	subq	$16,	%rsp

	movq	%rbx,	-8(%rbp)
	xorq	%rbx,	%rbx

	cmpb	$'-',	(%rdi)
	jne	1f

	incq	%rdi
	movq	$1,	%rbx

	1:
	call	parse_uint

	testq	%rbx,	%rbx
	jz	2f

	negq	%rax
	incq	%rdx

	2:
	movq	-8(%rbp),	%rbx
	leave
	ret

.globl string_equals
string_equals:
	movq	$1,	%rax

	1:
	xorq	%rcx,	%rcx
	xorq	%rdx,	%rdx

	movb	(%rdi),	%cl
	movb	(%rsi),	%dl

	cmpq	%rcx,	%rdx
	jne	2f

	testq	%rcx,	%rcx
	jz	3f

	incq	%rdi
	incq	%rsi

	jmp	1b

	2:
	xorq	%rax,	%rax

	3:
	ret

.globl string_copy
string_copy:
	xorq	%rcx,	%rcx
	movq	%rdi,	%rax
	decq	%rdx

	1:
	cmpq	%rdx,	%rcx
	jge	3f

	xorq	%r10,	%r10
	movb	(%rdi),	%r10b
	movb	%r10b,	(%rsi)

	incq	%rdi
	incq	%rsi

	incq	%rcx

	cmpb	$0,	(%rdi)
	jne	1b

	movb	$0, 	(%rsi)

	2:
	ret

	3:
	xorq	%rax,	%rax
	jmp	2b

