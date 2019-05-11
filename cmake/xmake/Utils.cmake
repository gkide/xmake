macro(xset __var__ __val__)
    set(${__var__} "${__val__}" PARENT_SCOPE)
endmacro()