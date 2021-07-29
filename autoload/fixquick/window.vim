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

function! fixquick#window#copen_without_moving_cursor() abort
    let must_go_back = &buftype != 'quickfix'
    keepalt keepjumps copen
    if must_go_back
        keepalt keepjumps wincmd p
    endif
endf

function! fixquick#window#show_first_error_without_jump() abort
    call fixquick#window#show_error_without_jump('cfirst', 'cnext')
endf

function! fixquick#window#show_last_error_without_jump() abort
    call fixquick#window#show_error_without_jump('clast', 'cprev')
endf

function! fixquick#window#show_error_without_jump(dest, next) abort
    let only_errors = filter(getqflist(), { k,v -> v.bufnr != 0 })
    if empty(only_errors)
        " Avoid jumping anywhere if there's no error to jump to.
        echo "No errors"
        return
    endif
    let winview = winsaveview()
    let winnr = winnr()
    let bufnr = bufnr()
    " to end of buffer
    exec 'keepalt keepjumps' a:dest
    try
        " to actual error
        exec 'keepalt keepjumps' a:next
    catch /^Vim\%((\a\+)\)\=:E553/	" Error: No more items
    endtry
    call execute(winnr ..'wincmd w')
    call execute('keepalt '.. bufnr ..'buffer')
    call winrestview(winview) 
endf

