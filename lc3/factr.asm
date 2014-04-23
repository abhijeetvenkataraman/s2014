            .ORIG   x3000

            LD      R6, Base        ; Initialize Stack (R6)
            NOT     R6, R6          ; ...negate Base
            ADD     R6, R6, #1      ; R6 = -Base
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
            ST      R1, SaveR1      ; Preserve R1
            JSR     POP             ; Pop n from stack
            LD      R1, SaveFact    ; Restore (n - 1)! to R1
            JSR     MUL             ; R0 = n * (n - 1)!
            LD      R1, SaveR1      ; Retrieve R1
            LD      R7, SaveLink    ; Restore return link to R7
            BR      Done            ; All done!
Cleanup     LD      R0, SaveFact    ; Stack underflow: R0 = (n - 1)!
Done        RET

SaveLink    .FILL   x0
SaveFact    .FILL   x0
SaveR1      .FILL   x0

; Fake multiplication subroutine
MUL         ADD     R0, R0, R1
            RET

POP         ST      R2, Save2
            ST      R1, Save1
            LD      R1, Base
            ADD     R1, R1, #-1
            ADD     R2, R6, R1
            BRz     Failure
            LDR     R0, R6, #0
            ADD     R6, R6, #1
            BR      Success
PUSH        ST      R2, Save2
            ST      R1, Save1
            LD      R1, Max
            ADD     R2, R6, R1
            BRz     Failure
            ADD     R6, R6, #-1
            STR     R0, R6, #0
Success     LD      R1, Save1
            LD      R2, Save2
            AND     R5, R5, #0
            RET
Failure     LD      R1, Save1
            LD      R2, Save2
            AND     R5, R5, #0
            ADD     R5, R5, #1
            RET

Base        .FILL   xC001
Max         .FILL   xC00A
Save1       .FILL   x0
Save2       .FILL   x0

            .END
