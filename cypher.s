; Autor reseni: 

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xmrkva04"  ; sem doplnte vas login
cipher:         .space  17          ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
    .text

    ; xmrkva04-r29-r28-r3-r12-r0-r4
main:
    daddi r12, r0, 0
    daddi r28, r0, 0

    __mainloop:
    lb      r29, login(r3)
    sltiu   r12, r29, 97        ;check if character is number
    bne     r12,r0, __end          ;if yes, jump to end
    bne     r28,r0, __cyphersub

    __cypheradd:
    daddi   r29, r29, 13            ;use +13 (m) as a key
    daddi   r4, r0, 122
    sltu    r12, r4, r29
    bne     r12,r0, __overflowfixsub
    sb      r29, cipher(r3)
    daddi   r3, r3, 1
    daddi   r28, r0, 1
    B   __mainloop

    __cyphersub:                    ;use -18 (r) as a key
    daddi   r29, r29, -18
    sltiu   r12, r29, 97
    bne     r12,r0, __overflowfixadd
    sb      r29, cipher(r3)
    daddi   r3, r3, 1
    daddi   r28, r0, 0
    B   __mainloop

    __overflowfixadd:               ;fix for overflow below alphabet (ascii < 97)
    daddi   r29, r29, 26
    sb      r29, cipher(r3)
    daddi   r3, r3, 1
    daddi   r28, r0, 0
    B   __mainloop

    __overflowfixsub:               ;fix for overflow above alphabet (ascii > 122)
    daddi   r29, r29, -26
    sb      r29, cipher(r3)
    daddi   r3, r3, 1
    daddi   r28, r0, 1
    B   __mainloop

    __end:
    daddi   r4, r0, cipher          ;move cipher into r4 and print
    jal     print_string
    syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
    sw      r4, params_sys5(r0)
    daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
    syscall 5   ; systemova procedura - vypis retezce na terminal
    jr      r31 ; return - r31 je urcen na return address