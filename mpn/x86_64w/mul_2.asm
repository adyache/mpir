
;  X86_64 mpn_mul_2
;
;  Copyright 2008 Jason Moxham
;
;  Windows Conversion Copyright 2008 Brian Gladman
;
;  This file is part of the MPIR Library.
;  The MPIR Library is free software; you can redistribute it and/or modify
;  it under the terms of the GNU Lesser General Public License as published
;  by the Free Software Foundation; either version 2.1 of the License, or (at
;  your option) any later version.
;  The MPIR Library is distributed in the hope that it will be useful, but
;  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
;  License for more details.
;  You should have received a copy of the GNU Lesser General Public License
;  along with the MPIR Library; see the file COPYING.LIB.  If not, write
;  to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;  Boston, MA 02110-1301, USA.
;
;  Calling interface:
;
;  dst[] = src[] / f    
;
;  mp_limb_tmpn_divexact_byBm1of (
;     mp_ptr dst,                rcx
;     mp_srcptr src1,            rdx
;     mp_size_t len,              r8
;     mp_srcptr src2              r9
;  )
;
;  This is an SEH frame function
;
%include "yasm_mac.inc"

%define reg_save_list rsi, rdi, rbx

    BITS 64

	FRAME_PROC mpn_mul_2, 0, reg_save_list
	movsxd  rax, r8d
	
	mov     r8, [r9]
	lea     rsi, [rdx+rax*8-24]
	lea     rdi, [rcx+rax*8-24]
	mov     rcx, [r9+8]
	mov     rbx, 3
	sub     rbx, rax
	mov     r10, 0
	mov     rax, [rsi+rbx*8]
	mul     r8
	mov     r11, rax
	mov     r9, rdx
	cmp     rbx, 0
	jge     .2
	
	xalign  16
.1: mov     rax, [rsi+rbx*8]
	mov     [rdi+rbx*8], r11
	mul     rcx
	add     r9, rax
	adc     r10, rdx
	mov     r11, 0
	mov     rax, [rsi+rbx*8+8]
	mul     r8
	add     r9, rax
	mov     rax, [rsi+rbx*8+8]
	adc     r10, rdx
	adc     r11, 0
	mul     rcx
	add     r10, rax
	mov     [rdi+rbx*8+8], r9
	adc     r11, rdx
	mov     rax, [rsi+rbx*8+16]
	mul     r8
	mov     r9, 0
	add     r10, rax
	mov     rax, [rsi+rbx*8+16]
	adc     r11, rdx
	mov     [rdi+rbx*8+16], r10
	mov     r10, 0
	adc     r9, 0
	mul     rcx
	add     r11, rax
	mov     rax, [rsi+rbx*8+24]
	adc     r9, rdx
	mul     r8
	add     r11, rax
	adc     r9, rdx
	adc     r10, 0
	add     rbx, 3
	jnc     .1

.2:	mov     rax, [rsi+rbx*8]
	mov     [rdi+rbx*8], r11
	mul     rcx
	add     r9, rax
	adc     r10, rdx
	cmp     rbx, 1
	ja      .32
	je      .31

.30:mov     r11, 0
	mov     rax, [rsi+rbx*8+8]
	mul     r8
	add     r9, rax
	mov     rax, [rsi+rbx*8+8]
	adc     r10, rdx
	adc     r11, 0
	mul     rcx
	add     r10, rax
	mov     [rdi+rbx*8+8], r9
	adc     r11, rdx
	mov     rax, [rsi+rbx*8+16]
	mul     r8
	mov     r9, 0
	add     r10, rax
	mov     rax, [rsi+rbx*8+16]
	adc     r11, rdx
	mov     [rdi+rbx*8+16], r10
	adc     r9, 0
	mul     rcx
	add     r11, rax
	adc     r9, rdx
	mov     [rdi+rbx*8+24], r11
	mov     rax, r9
	jmp     .4

	xalign  16
.31:mov     r11, 0
	mov     rax, [rsi+rbx*8+8]
	mul     r8
	add     r9, rax
	mov     rax, [rsi+rbx*8+8]
	adc     r10, rdx
	adc     r11, 0
	mul     rcx
	add     r10, rax
	mov     [rdi+rbx*8+8], r9
	adc     r11, rdx
	mov     [rdi+rbx*8+16], r10
	mov     rax, r11
	jmp     .4
	
	xalign  16
.32:mov     [rdi+rbx*8+8], r9
	mov     rax, r10

.4: END_PROC reg_save_list

    end
