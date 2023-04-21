.syntax unified
.cpu cortex-m4
.thumb

.globl _start

.text
	.word	0x20000200
	.word	_reset + 1
	.word	_nmi_handler + 1
	.word	_hard_fault + 1
	.word	_memory_fault + 1
	.word	_bus_fault + 1
	.word	_usage_fault + 1

_start:
_reset:
	ldr r0, =0x40023830			// RCC_AHB1ENR
	Ldr r1, [r0]
	ldr r2, =0x4
	orrs r1, r2
	str r1, [r0]
	nop
	nop
	nop

	ldr r0, =0x40020800			// GPIOC_MODER
	ldr r1, [r0]
	ldr r2, =0x4000000
	orrs r1, r2 
	str r1, [r0]

	ldr r0, =0x40020818			// GPIOC_BSRR

_blink_loop:
	ldr r1, =0x2000
	str r1, [r0]
	bl _delay
	ldr r1, =0x20000000
	str r1, [r0]
	bl _delay
	b _blink_loop

_delay:
	push {r4}
	ldr r4, =0x100000
_delay_loop:
	subs r4, #1
	bne _delay_loop
	pop {r4}
	bx lr

_dummy:
_nmi_handler:
_hard_fault:
_memory_fault:
_bus_fault:
_usage_fault:
	b _dummy

