        .ORIG   x3000
        AND     R0, R0, #0  ; R0 = 0
        ADD     R0, R0, #5  ; R0 = 5
        AND     R1, R1, #0  ; R1 = 0
        ADD     R1, R1, #9  ; R1 = 9
        JSR     MUL
        HALT

MUL     
        ; Save register values for later
        ST      R2, SAVE_R2
        ST      R3, SAVE_R3
        ST      R4, SAVE_R4

        ; Do some crazy math (feeling free to use R0..R4)
        AND     R2, R2, #0
        AND     R3, R3, #13     ; xD
        AND     R4, R4, xF
        ADD     R0, R1, R0      ; R0 = R1 + R0

        ; Restore the register values, (duh, it's later!)
        LD      R4, SAVE_R4
        LD      R3, SAVE_R3
        LD      R2, SAVE_R2

        RET

SAVE_R2 .BLKW 1
SAVE_R3 .FILL 0
SAVE_R4 .BLKW 1

        .END

