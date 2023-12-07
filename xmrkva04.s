; Autor reseni: Adam Mrkva xmrkva04
; Pocet cyklu k serazeni puvodniho retezce: 6300
; Pocet cyklu razeni sestupne serazeneho retezce: 6540
; Pocet cyklu razeni vzestupne serazeneho retezce: 5815
; Pocet cyklu razeni retezce s vasim loginem: 1190
; Implementovany radici algoritmus: bubble sort
; ------------------------------------------------
;login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec

; DATA SEGMENT
                .data
login:          .asciiz "xmrkva04"                                          

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text
main:
        daddi   r15, r0, 0
        daddi   r20, r0, 0
        daddi   r21, r0, 0
        daddi   r7, r0, 7

        __reset:
        daddi   r5, r0, 0
        daddi   r6, r5, 1

        daddi   r10, r0, 0
        daddi   r11, r0, 0

        __loop:
        lb      r10, login(r5)
        lb      r11, login(r6)  ;load the two characters (x and x+1) from login
        beqz    r11, __cycle    ;if the value of x+1 is null, jump to print section = end of string
        sltu    r15, r11, r10   ;compare the two laded chars, if second is greater then first, set r15 to 1
        BNEZ    r15, __swap     ;swap the characters
        B       __loopend
        
        __loopend:              ;write them into the login
        sb      r10, login(r5)
        sb      r11, login(r6)

        daddi   r5, r5, 1       ;increment counters
        daddi   r6, r5, 1
        B       __loop

        __swap:                 ;swap
        dadd r12, r0, r10
        dadd r10, r0, r11
        dadd r11, r0, r12
        B       __loopend

        __cycle:                ;cycle the code n times
        dadd    r20, r0, r5
        daddi   r21, r21, 1
        BNE     r20, r21, __reset

        __end:
        daddi    r4, r0, login  ; vozrovy vypis: adresa login: do r4
        jal     print_string    ; vypis pomoci print_string - viz nize
        syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
