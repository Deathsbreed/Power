.section .data

.section .text
    .globl _start

_start:
    pushq $3                         # push the second argument
    pushq $2                         # push the first argument
    call power                      # call the function
    addq $16, %rsp                    # move the stack pointer back
    pushq %rax                       # save the first answer on stack
    pushq $2                         # push the second argument
    pushq $5                         # push the first argument
    call power                      # call the function
    addq $16, %rsp                    # move the stack pointer back

    popq %rdi                        # the second answer is still in %rax,
                                    # so we can put the first one from the
                                    # stack to %rdi to keep both answers
    addq %rax, %rdi                  # add them together and store result
                                    # in %rdi
    movq $60, %rax                   # exit (%rdi is returned)
    syscall

#VARIABLES:
#       %rdi - holds the base number
#       %rsi - holds the power
#       -4(%rbp) - holds the current result
#
#       %rax is used for tmp storage
#
.type power, @function
power:
    pushq %rbp                       # save old base pointer
    movq %rsp, %rbp                  # make stack pointer the base pointer
    subq $8, %rsp                    # get room for our local storage

    movq 16(%rbp), %rdi              # put first argument in %rdi
    movq 24(%rbp), %rsi              # put second argument in %rsi

    movq %rdi, -4(%rbp)              # store the current result

    power_loop_start:
        cmpq $1, %rsi                # if the power is 1, don't do shit
        je end_power
        movq -4(%rbp), %rax          # move the current result into %rax
        imulq %rdi, %rax             # multiply the current result by the
                                    # base number
        movq %rax, -4(%rbp)          # store the current result

        decq %rsi                    # decrease the power (one down)
        jmp power_loop_start        # run for the next power

    end_power:
        movq -4(%rbp), %rax          # return value goes in %rax
        movq %rbp, %rsp              # restore the stack pointer
        popq %rbp                    # restore the base pointer
        ret
