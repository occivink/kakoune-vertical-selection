try %{
    require-module vertical-selection
} catch %{
    source vertical-selection.kak
    require-module vertical-selection
}

define-command assert-selections-are -params 1 %{
    eval %sh{
        if [ "$1" != "$kak_quoted_selections" ]; then
            printf 'fail "Check failed"'
        fi
    }
}

edit -scratch *vertical-selection-test-1*

exec 'iline1<ret>line2<ret>line3<ret>line4<esc>'

exec 'ggl' # select first 'i'
assert-selections-are "'i'"
vertical-selection-down
assert-selections-are "'i' 'i' 'i' 'i'"

exec 'geghll' # select last 'n'
assert-selections-are "'n'"
vertical-selection-down
assert-selections-are "'n'"
vertical-selection-up
assert-selections-are "'n' 'n' 'n' 'n'"

exec 'ggj' # select second l, and then down
assert-selections-are "'l'"
vertical-selection-down
assert-selections-are "'l' 'l' 'l'"

exec 'ggj' # select second l, and then up
assert-selections-are "'l'"
vertical-selection-up
assert-selections-are "'l' 'l'"

exec 'gggl' # select first number
vertical-selection-up-and-down
assert-selections-are "'1'"

exec 'ggglj' # select second number
vertical-selection-up-and-down
assert-selections-are "'2'"

exec 'ggLLL' # select entire 'line'
vertical-selection-down
assert-selections-are "'line' 'line' 'line' 'line'"

# TODO tests with multi-selection as input

delete-buffer
