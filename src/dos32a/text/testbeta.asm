;
; Copyright (C) 1996-2006 by Narech K. All rights reserved.
;
; Redistribution  and  use  in source and  binary  forms, with or without
; modification,  are permitted provided that the following conditions are
; met:
;
; 1.  Redistributions  of  source code  must  retain  the above copyright
; notice, this list of conditions and the following disclaimer.
;
; 2.  Redistributions  in binary form  must reproduce the above copyright
; notice,  this  list of conditions and  the  following disclaimer in the
; documentation and/or other materials provided with the distribution.
;
; 3. The end-user documentation included with the redistribution, if any,
; must include the following acknowledgment:
;
; "This product uses DOS/32 Advanced DOS Extender technology."
;
; Alternately,  this acknowledgment may appear in the software itself, if
; and wherever such third-party acknowledgments normally appear.
;
; 4.  Products derived from this software  may not be called "DOS/32A" or
; "DOS/32 Advanced".
;
; THIS  SOFTWARE AND DOCUMENTATION IS PROVIDED  "AS IS" AND ANY EXPRESSED
; OR  IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT  LIMITED  TO, THE IMPLIED
; WARRANTIES  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED.  IN  NO  EVENT SHALL THE  AUTHORS  OR  COPYRIGHT HOLDERS BE
; LIABLE  FOR  ANY DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL  DAMAGES  (INCLUDING, BUT NOT  LIMITED TO, PROCUREMENT OF
; SUBSTITUTE  GOODS  OR  SERVICES;  LOSS OF  USE,  DATA,  OR  PROFITS; OR
; BUSINESS  INTERRUPTION) HOWEVER CAUSED AND  ON ANY THEORY OF LIABILITY,
; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
; OTHERWISE)  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
; ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;
;

;=============================================================================
; Low-level debugging support for beta releases
;
; Note: this code is shared between CLIENT & KERNEL; whenever there is a need
;	to differentiate between the two (seg/sel regs and such), use the
;	BUILDING_KERNEL and BUILDING_CLIENT macro symbols
;
;=============================================================================


;=============================================================================
; write the contents of AL (8-bit) register to STDOUT
;
dbg_hexal:
	push	dx
	mov	dx,offs hexbuf+6
	jmp	mkhex

;=============================================================================
; write the contents of AX (16-bit) register to STDOUT
;
dbg_hexax:
	push	dx
	mov	dx,offs hexbuf+4
	jmp	mkhex

;=============================================================================
; write the contents of EAX (32-bit) register to STDOUT
;
; works from real & protected modes, should be fairly transparent to the app
;
dbg_hexeax:
	push	dx
	mov	dx,offs hexbuf
mkhex:	push	eax cx si di ds dx
	smsw	si
	test	si,1
	jz	@@0
;
; TODO: rewrite this shit pronto! (in particular avoid memory r/w access a la CLIENT/strings.asm)
;

If BUILDING_KERNEL eq 0
	mov	ds,cs:_sel_ds
	jmp	@@1
@@0:	mov	ds,cs:_seg_ds
Else
	mov	ds,cs:seldata
	jmp	@@1
@@0:	mov	ds,cs:kernel_code
Endif

@@1:	mov	di,7

@@cvt:	mov	si,ax
	and	si,000Fh
	mov	cl,cs:hextab[si]
	mov	ds:hexbuf[di],cl
	shr	eax,4
	dec	di
	jns	@@cvt
	pop	si

	mov	cx,offs hexbuf+10
	sub	cx,si
@@loop:	lodsb
	mov	dl,al
	mov	ah,2
	int	21h
	loop	@@loop
	pop	ds di si cx eax dx
	ret
hextab	db '0123456789ABCDEF'
hexbuf	db '        ',13,10


;=============================================================================
; pause until a key is pressed
;
; note: this switches CPU to real mode (BIOS Fn Int16h/AX=0)
;
dbg_kbhit:
	push	ax
	xor	ax,ax
	int	16h
	pop	ax
	ret

;=============================================================================
; beep a sound from the PC speaker
;	AX = frequency
;	CX = time
;
dbg_beep:
@@0:	push	cx dx ax		; AX=frequency, CX=time
	mov	al,0B6h			; set frequency
	out	43h,al
	pop	ax
	out	42h,al			; fLow
	mov	al,ah
	out	42h,al			; fHigh
	in	al,61h			; beep on
	or	al,03h
	out	61h,al
@@loop:	in	al,40h
	in	al,40h
	mov	ah,al
@@1:	in	al,40h
	in	al,40h
	cmp	ah,al
	je	@@1
	loop	@@loop
	in	al,61h			; beep off
	and	al,not 03h
	out	61h,al
	pop	dx cx
	ret

;=============================================================================
; halt execution forever
;
; this blocks app execution in an endless loop, with predicate AX being tested
; for being zero; the state of AX is then expected to be changed by an external
; debugger (i.e. from an emulator) so that debugging can proceed from that point
;
dbg_halt:
	pushf
	cli
	push	ax
	xor	ax,ax
@@loop:	test	ax,ax
	jz	@@loop
	pop	ax
	sti
	popf
	ret

;=============================================================================
; convinience fn: peep a beep, then die a little in hope of a better future
;
; real men don't use no hardware debuggers!
;
dbg_break:
	pushf
	push	ax cx
	mov	cx,0200h
	mov	ax,0500h
	call	dbg_beep
	mov	ax,0100h
	call	dbg_beep
	mov	ax,0500h
	call	dbg_beep
	pop	cx ax
	popf
	jmp	dbg_halt

