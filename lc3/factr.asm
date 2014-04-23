            .ORIG   x3000

            LD      R6, BASE        ; Initialize Stack (R6)
            NOT     R6, R6          ; ...negate BASE
            ADD     R6, R6, #1      ; R6 = -BASE
            AND     R0, R0, #0
            ADD     R0, R0, #4
            JSR     FACTR           ; Call 4!
            HALT

FACTR       ST      R0, SaveFact    ; Save n
            ADD     R0, R0, #-1     ; Test for n <= 1...
            BRnz    Cleanup         ; ...if so, we're done
            ST      R7, SaveLink    ; Save return link
            LD      R0, SaveFact    ; Restore n to R0
            JSR     PUSH            ; Push n to stack
            LD      R0, SaveLink    ; Restore return link to R0
            JSR     PUSH            ; Push return link to stack
            LD      R0, SaveFact    ; Calculate...
            ADD     R0, R0, #-1     ; ...R0 = n - 1
            JSR     FACTR           ; Recurse to (n - 1)!

            ST      R0, SaveFact    ; Save (n - 1)!
            JSR     POP             ; Pop return link from stack
            ADD     R5, R5, #0      ; Check for underflow
            BRp     Cleanup         ; Wrap up if stack is empty
            ST      R0, SaveLink    ; Save return link
            ST      R1, SAVE_R1     ; Protect R1
            JSR     POP             ; Pop n from stack
            LD      R1, SaveFact    ; Restore (n - 1)! to R1
            JSR     MUL             ; R0 = n * (n - 1)!
            LD      R1, SAVE_R1     ; Retrieve R1
            LD      R7, SaveLink    ; Restore return link to R7
            BR      Done            ; All done!
Cleanup     LD      R0, SaveFact    ; Stack underflow: R0 = (n - 1)!
Done        RET

SaveLink    .FILL   x0
SaveFact    .FILL   x0
SAVE_R1     .FILL   x0

MUL         ADD     R0, R0, R1
            RET

POP         ST      R2, SAVE2
            ST      R1, SAVE1
            LD      R1, BASE
            ADD     R1, R1, #-1
            ADD     R2, R6, R1
            BRz     FAILURE
            LDR     R0, R6, #0
            ADD     R6, R6, #1
            BR      SUCCESS
PUSH        ST      R2, SAVE2
            ST      R1, SAVE1
            LD      R1, MAX
            ADD     R2, R6, R1
            BRz     FAILURE
            ADD     R6, R6, #-1
            STR     R0, R6, #0
SUCCESS     LD      R1, SAVE1
            LD      R2, SAVE2
            AND     R5, R5, #0
            RET
FAILURE     LD      R1, SAVE1
            LD      R2, SAVE2
            AND     R5, R5, #0
            ADD     R5, R5, #1
            RET

BASE        .FILL   xC001
MAX         .FILL   xC00A
SAVE1       .FILL   x0
SAVE2       .FILL   x0

            .END
