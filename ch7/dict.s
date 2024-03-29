.extern string_equals
.extern string_length

.text
.globl find_word
find_word: /* (const char *key, void *dict) -> void *header */
	pushq	%rbp
	movq	%rsp,		%rbp
	subq	$16,		%rsp

	movq	%rbx,		-8(%rbp)
	movq	%r15,		-16(%rbp)

	movq	%rdi,		%r15
	movq	%rsi,		%rbx

	1:
	testq	%rbx,		%rbx
	jz	2f

	movq	%r15,		%rdi
	leaq	8(%rbx),	%rsi
	call	string_equals

	testq	%rax,		%rax
	jnz	3f

	movq	(%rbx),		%rbx

	jmp	1b

	2:
	xorq	%rax,		%rax
	jmp	4f

	3:
	leaq	8(%rbx),	%rax

	4:
	movq	-8(%rbp),	%rbx
	movq	-16(%rbp),	%r15

	leave
	ret

.globl cfa
cfa: /* (const void *header) -> void *xt_addr */
	pushq	%rbp
	movq	%rsp,		%rbp
	subq	$16,		%rsp

	movq	%rbx,		-8(%rbp)

	movq	%rdi,		%rbx

	call	string_length
	incq	%rax

	leaq	2(%rbx, %rax),	%rax

	movq	-8(%rbp),	%rbx

	leave
	ret

