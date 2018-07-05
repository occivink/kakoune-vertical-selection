# copy the current selection upwards/downwards to all lines matching the current selection

define-command select-up -docstring "
Select matching patterns from the lines above
" %{
    try %{
        # throw if we're at the top of the buffer
        exec -draft "gh<a-C><a-space>"
        exec "<space><a-:><a-;>"
        select-impl "<a-?>" "\n"
        exec "<a-:>"
    }
}

define-command select-down -docstring "
Select matching patterns from the lines below
" %{
    try %{
        # throw if we're at the bottom of the buffer
        exec -draft "ghC<a-space>"
        exec "<space><a-:>"
        select-impl "?" "^"
    }
}

define-command select-vertically -docstring "
Select matching patterns from the lines above and below
" %{
    eval %{
        eval -save-regs '' -draft %{
            select-up
            exec -save-regs '' Z
        }
        select-down
        exec <a-z>a
        # silence the register message, it's an implementation detail
        echo
    }
}

define-command -hidden select-impl -params 2 %{
    eval -save-regs 'p/"' %{
        exec '"p<a-*>'
        # put the initial pattern in a capture group so we can come back to it
        reg p "(%reg{p})"
        try %{
            exec "<a-K>^<ret>"
            # pattern is not at the beginning of the line
            eval -draft %{
                # select every character on the same line before the pattern
                exec "<a-:><a-;>;hGhs.<ret>"
                # and require as many [^\n] to precede the pattern we're searching for
                reg p "[^\n]{%reg{#}}%reg{p}"
            }
        }
        reg p "^%reg{p}"
        # extend / reverse extend the selection to get all lines that match the pattern at the same position
        reg / "((%reg{p}[^\n]*\n)+|%arg{2})"
        exec "%arg{1}<ret><a-x>"
        # and select the pattern back from this selection
        exec '<a-s>"p1s<ret>'
    }
}
