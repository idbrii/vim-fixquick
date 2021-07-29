" Resize the quickfix to match the number of entries marked as errors. If
" errorformat doesn't use %t (parse the type of error), then it counts all
" entries as errors.
function! fixquick#window#resize_qf_to_errorcount(minimum_height, maximum_height) abort
    let qf = getqflist()
    if empty(qf)
        return
    endif
    
    if &errorformat =~# '%t'
        " Entries marked as errors.
        let n_errors = len(filter(qf, {i,v -> v.type == 'e'}))
    else
        " Entries that point to a file.
        let n_errors = len(filter(qf, {i,v -> v.bufnr != 0}))
    endif

    let qf_winid = getqflist({'winid' : 1}).winid
    if qf_winid == 0
        cwindow
    endif
    
    let height = fixquick#math#clamp(a:minimum_height, a:maximum_height, n_errors)
    exec qf_winid 'resize ' height
endf
