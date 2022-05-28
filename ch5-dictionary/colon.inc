.set last_node, 0x0

.macro colon key:req label:req
\label\():
	.quad 	last_node
	.string	"\key"
	.set last_node, \label
.endm

