.set last_node, 0x0

.macro native word:req, label:req, flags=0
.section .rodata
w_\label\():
	.quad last_node
	.set last_node, w_\label
	.string "\word"
	.byte \flags

xt_\label\():
	.quad impl_\label

.text
impl_\label\():
.endm


.macro colon word:req, label:req
.section .rodata
w_\label\():
	.quad last_node
	.set last_node, w_\label
	.string "\word"
	.byte 0x0

xt_\label\():
	.quad impl_docol
.endm

