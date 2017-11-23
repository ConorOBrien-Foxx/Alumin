# Alumin

Alumin is a language whose commands are entirely lowercase letters, and nothing else. It operates on a stack.

## Commands

    a   push the sum of the top two members on stack
    b   push modulo of top two members on stack
    c   push difference between top two members on stack
    d   duplicate top of stack
    e   push equality of top two members
    f   read commands until the next f; folds the stack over those commands.
    g   divide top two members on stack
    h   a run of N hs in a row pushes the number N
    i   read a character from stdin
    j   read a number from stdin
    k   discard top of stack
    l   push the length of the stack
    m   same as f, but maps instead of folds.
    n   print a number
    o   print top of stack as a character
    p   end loop (while positive)
    q   start loop (while positive)
    r   reverse stack
    s   pop a stack off the stack stack
    t   push product of top two members of stack
    u   push greater of top two members of stack
    v   push lesser of top two members of stack
    w   pop top N members into a new stack; put old stack onto the stack stack
    x   push a random number between 0 and the top of the stack (right exclusive)
        if the top of the stack is 0, push a random float between 0 and 1
    y   swap top two members on stack
    z   push 0