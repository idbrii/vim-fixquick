" fixquick - utilities for the quickfix


" Resize the quickfix to match the number of entries marked as errors. If
" errorformat doesn't use %t (parse the type of error), then it counts all
" entries as errors.
function! fixquick#window#resize_qf_to_errorcount(minimum_height, maximum_height) abort
    let qf = getqflist()
    if empty(qf)
        return 0
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
        let qf_winid = getqflist({'winid' : 1}).winid
    endif

    if qf_winid == 0
        " No qf window to resize.
        return 0
    endif
    
    if winheight(qf_winid) > (&lines - 10)
        " qf window exists but is using most of the screen. Probably has no
        " windows above or below it and :resize would change the entire
        " visible area and look broken. Do nothing instead.
        return 0
    endif
    
    let height = fixquick#math#clamp(a:minimum_height, a:maximum_height, n_errors)
    exec qf_winid 'resize ' height
    return 1
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
    split
    " to end of buffer
    exec 'keepalt keepjumps' a:dest
    try
        " to actual error
        exec 'keepalt keepjumps' a:next
    catch /^Vim\%((\a\+)\)\=:E553/	" Error: No more items
    endtry
    close
    call execute(winnr ..'wincmd w')
    call execute('keepalt '.. bufnr ..'buffer')
    call winrestview(winview) 
endf


" Quickly open/close quickfix
"
" I haven't figured out how to just toggle, but this is the closest. If we're
" in the quickfix/locationlist, close it. Otherwise open it.
function! fixquick#window#quick_fix_toggle(prefix) abort
    if len(a:prefix) != 1
        echoerr 'QuickFixToggle requires the prefix of l or c'
        return
    endif

    if &buftype == 'quickfix'
        " If we're already in a quickfix window, then we should close it.
        " We use [cl]close instead of :quit to ensure that we close the
        " requested window.
        execute a:prefix . 'close'
    else
        " If we're not in a quickfix buffer, try to open a quickfix of the
        " requested type.
        execute a:prefix . 'open'
        let b:fixquick_prefix = a:prefix
    endif
endfunction


function! fixquick#window#split_if_necessary_and_jump() abort
    let prefix = b:fixquick_prefix

    " .cc or .ll depending on the quickfix type.
    let display_error_cmd = '.'. prefix . prefix
    try
        execute display_error_cmd
    catch /^Vim\%((\a\+)\)\=:E37/	" No write since last change
        " Theoretically equivalent to: execute "normal! \<C-w>\<CR>"
        " But that doesn't work.
        split
        wincmd p
        execute display_error_cmd
    endtry
endf


function! fixquick#window#preview_toggle() abort
    if &previewwindow
        " If we're already in a preview window, then close it.
        pclose
    else
        " If we're not in a preview window, try to open it.
        wincmd P
    endif
endf
