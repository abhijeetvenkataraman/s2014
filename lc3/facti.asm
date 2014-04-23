        .ORIG   x3000

        AND     R0, R0, #0
        ADD     R0, R0, #6
        JSR     FACTI
        HALT

MUL     ;;; R0 <- R0 * R1
        ADD     R0, R0, R1
        RET

FACTI   ;;; R0 <- R0!
        ST      R1, SAVE_R1   ; Protect R1
        ADD     R1, R0, #0    ; R1 = R0

        ADD     R1, R1, #-1   ; Setup test
WHILE   BRnz    DONE
        ST      R7, SAVE_R7   ; Protect R7
        JSR     MUL           ; total *= value
        LD      R7, SAVE_R7   ; Restore R7
        ADD     R1, R1, #-1   ; value--
        BRnzp   WHILE

DONE    LD      R1, SAVE_R1   ; Restore R1
        RET

SAVE_R1 .BLKW   1
SAVE_R7 .BLKW   1
        .END