function! fixquick#math#clamp(minimum, maximum, val) abort
    if a:val > a:maximum
        return a:maximum
    endif
    if a:val < a:minimum
        return a:minimum
    endif
    return a:val
endf
