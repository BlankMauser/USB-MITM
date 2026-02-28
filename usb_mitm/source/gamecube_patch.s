.section .text.UsbServicePatchBegin, "ax", %progbits
.global UsbServicePatchBegin
.type UsbServicePatchBegin, %function
.hidden UsbServicePatchBegin
.align 2
.cfi_startproc
UsbServicePatchBegin:
    stp x0, x1, [sp, #-16]!
    stp x2, x3, [sp, #-16]!
    mrs x2, nzcv
    mov x1, #0x1e65
    add x0, x20, x1
    ldrh w1, [x0, #0x2]
    ldrh w0, [x0]
    cmp w0, #0x057e
    b.ne UsbServicePatchEarlyExit
    cmp w1, #0x0337
    b.ne UsbServicePatchEarlyExit
    mov w0, #0x1
    strb w0, [x13, #0x6]

UsbServicePatchEarlyExit:
    msr nzcv, x2
    ldp x2, x3, [sp], #0x10
    ldp x0, x1, [sp], #0x10
    ldr w14, [x13] // Replacing the instruction that we hook to get here
    ret
.global UsbServicePatchEnd
UsbServicePatchEnd:
    .byte 0x69
.cfi_endproc
