;
;
; intro
;
        .ORIG   x3050           ; Start program at x3050
        LD      R1, SIX         ; R1 <- #6
        LD      R2, NUMBER      ; R2 <- #1
        AND     R3, R3, #0      ; R3 <- #0

; Inner loop
;
AGAIN   ADD     R3, R3, R2      ; R3 <- R3 + R2
        ADD     R1, R1, #-1     ; R1 <- R1 - #1
        BRp     AGAIN           ; Branch to inner loop, if R1 > 0
;
        HALT                    ; End execution
;
NUMBER  .BLKW   1               ; Number of values
SIX     .FILL   x0006           ; Value named "SIX" = #6
;
        .END
