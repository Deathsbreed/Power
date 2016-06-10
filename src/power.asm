.section .data

.section .text
    .globl _start

_start:
    movq $3, %rsi                   # second argument
    movq $2, %rdi                   # first argument
    call power                      # call the function
    pushq %rax                      # save the first answer on stack
    movq $2, %rsi                   # push the second argument
    movq $5, %rdi                   # push the first argument
    call power                      # call the function

    popq %rdi                       # the second answer is still in %rax,
                                    # so we can put the first one from the
                                    # stack to %rdi to keep both answers
    addq %rax, %rdi                 # add them together and store result
                                    # in %rdi
    movq $60, %rax                  # exit (%rdi is returned)
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
    pushq %rbp                      # save old base pointer
    movq %rsp, %rbp                 # make stack pointer the base pointer
    subq $8, %rsp                   # get room for our local storage

    movq %rdi, -8(%rbp)             # store the current result

    power_loop_start:
        cmpq $1, %rsi               # if the power is 1, don't do shit
        je end_power
        movq -8(%rbp), %rax         # move the current result into %rax
        imulq %rdi, %rax            # multiply the current result by the
                                    # base number
        movq %rax, -8(%rbp)         # store the current result

        decq %rsi                   # decrease the power (one down)
        jmp power_loop_start        # run for the next power

    end_power:
        movq -8(%rbp), %rax         # return value goes in %rax
        movq %rbp, %rsp             # restore the stack pointer
        popq %rbp                   # restore the base pointer
        ret
