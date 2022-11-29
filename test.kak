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

# content is
# line1
# line2
# line3
# line4
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

delete-buffer

edit -scratch *vertical-selection-test-2*

# content is:
# [a] b [c] d
#  b [b] c  e
#  a  b  c [e]
#  b  b  d  e
exec 'iabcd<ret>bbce<ret>abce<ret>bbde<esc>'
select 1.1,1.1 1.3,1.3 2.2,2.2 3.4,3.4
exec -save-regs '' 'Z'

exec 'z'
vertical-selection-down
assert-selections-are "'a' 'c' 'b' 'c' 'b' 'c' 'e' 'b' 'e'"

exec 'z'
vertical-selection-up
assert-selections-are "'a' 'b' 'c' 'b' 'e' 'e'"

exec 'z'
vertical-selection-up-and-down
assert-selections-are "'a' 'b' 'c' 'b' 'c' 'e' 'b' 'c' 'e' 'b' 'e'"

delete-buffer
