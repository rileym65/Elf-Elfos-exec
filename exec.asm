; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

include    bios.inc
include    kernel.inc

           org     8000h
           lbr     0ff00h
           db      'exec',0
           dw      9000h
           dw      endrom+2000h
           dw      7000h
           dw      endrom-7000h
           dw      7000h
           db      0

           org     7000h
           br      start

include    date.inc
include    build.inc
           db      'Written by Michael H. Riley',0

start:
           lda     ra                  ; move past any spaces
           smi     ' '
           lbz     start
           dec     ra                  ; move back to non-space character
           ldn     ra                  ; check for nonzero byte
           lbnz    good                ; jump if non-zero
           sep     scall               ; otherwise display usage
           dw      f_inmsg
           db      'Usage: exec address',10,13,0
           sep     sret                ; return to os
good:      ghi     ra                  ; copy argument address to rf
           phi     rf
           glo     ra
           plo     rf
           sep     scall               ; convert input to address
           dw      f_hexin
           ldi     high jump           ; point to jump address
           phi     rf
           ldi     low jump
           plo     rf
           inc     rf
           ghi     rd                  ; write in jump address
           str     rf
           inc     rf
           glo     rd
           str     rf
jump:      lbr     0                   ; jump to program

endrom:    equ     $

