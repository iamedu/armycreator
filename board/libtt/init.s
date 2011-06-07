	.global	_start

_start:
	b	res_exc
	b	und_exc
	b	swi_exc
	b	pfa_exc
	b	dfa_exc
	nop
	b	irq_exc
	b	fiq_exc

und_exc:

swi_exc:

pfa_exc:

dfa_exc:

irq_exc:

fiq_exc:

res_exc:
	
	mov	sp,	#1000

	b	main


