# copy the current selection upwards/downwards to all lines matching the current selection

define-command vertical-selection-up -docstring "
Select matching pattern from the lines above
" %{
    try %{
        # throw if we're at the top of the buffer
        exec -draft "gh<a-C><a-,>"
        exec ",<a-:><a-;>"
        vertical-selection-impl "<a-?>" "\n"
        exec "<a-:>"
    }
}

define-command vertical-selection-down -docstring "
Select matching pattern from the lines below
" %{
    try %{
        # throw if we're at the bottom of the buffer
        exec -draft "ghC<a-,>"
        exec ",<a-:>"
        vertical-selection-impl "?" "^."
    }
}

define-command vertical-selection-up-and-down -docstring "
Select matching pattern from the lines above and below
" %{
    eval %{
        eval -save-regs '' -draft %{
            vertical-selection-up
            exec -save-regs '' Z
        }
        vertical-selection-down
        exec <a-z>a
        # silence the register message, it's an implementation detail
        echo
    }
}

define-command -hidden vertical-selection-impl -params 2 %{
    eval -save-regs 'sp/"' %{
        # %reg{p} contains the regex to select all lines that potentially match the current
        # %reg{s} contains the regex to subselect the current pattern from that selection
        exec '"p<a-*>'
        try %{
            exec "<a-K>^<ret>"
            # pattern is not at the beginning of the line
            eval -draft %{
                # select every character on the same line before the pattern
                exec "<a-:><a-;>;hGh<ret>"
                # and require N chars to precede the pattern we're searching for
                # or lines that have fewer than N chars
                reg s "^.{%val{selection_length}}(%reg{p})"
                reg p "(?:^(?:.{%val{selection_length}}%reg{p}.*|.{,%reg{#}})\n)+"
            }
        } catch %{
            reg s "^(%reg{p})"
            # empty lines are accepted too
            reg p "^(?:%reg{p}[^\n]*\n|\n)+"
        }
        # extend (resp. reverse extend) to all lines that match the pattern (or are short enough)
        # or stop if the next (resp. previous) line is not a candidate
        reg / "(?S)(?:%reg{p}|%arg{2})"
        exec "%arg{1}<ret>x"
        # and select the pattern back from this selection
        reg / "(?S)%reg{s}"
        exec '<a-s>1s<ret>'
    }
}
