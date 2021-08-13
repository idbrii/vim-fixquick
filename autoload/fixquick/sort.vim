function! s:cmp(left, right) abort
    if a:left == a:right
        return 0
    elseif a:left < a:right
        return -1
    elseif a:left > a:right
        return 1
    endif
endf

function! fixquick#sort#cmp_retain_qforder(left, right) abort
    " Maintain order for unlisted
    return s:cmp(a:left.qforder, a:right.qforder)
endf

function! fixquick#sort#cmp_prioritize_error_or_listed(left, right) abort
    if a:left.bufnr == 0 || a:right.bufnr == 0
        " Maintain order for unlisted
        return fixquick#sort#cmp_retain_qforder(a:left, a:right)
    endif
    if a:left.type == 'e' && a:right.type == 'e'
        " Sort listed buffers first.
        return -1 * s:cmp(buflisted(a:left.bufnr), buflisted(a:right.bufnr))
    endif
    " Sort errors first.
    return -1 * s:cmp(a:left.type == 'e', a:right.type == 'e')
endf

" Call to rearrange the quickfix:
" * errors first
" * buffers you've explicitly opened ('buflisted')
" It will also maintain the order of buffers that don't have an associated
" file, so if you log your compile command and a timestamp on completion,
" those will stay at the beginning and end.
function! fixquick#sort#sort_by_buffers() abort
    let qf = getqflist()
    for i in range(0, len(qf)-1)
        let qf[i].qforder = i
    endfor
    let qf = qf->sort("fixquick#sort#cmp_prioritize_error_or_listed")
    call setqflist(qf)
endf

" Call to remove qf entries that point to the same file and line. cpp
" compilers like to output the same
function! fixquick#sort#remove_multiple_for_same_position() abort
    let qf = getqflist()
    let n_entries = len(qf)
    let seen = {}
    for i in range(0, len(qf)-1)
        let item = qf[i]
        let item.qforder = i
        let seen[printf("%i:%i:%i", item.bufnr, item.lnum, item.col)] = item
    endfor
    let qf = []
    for k in seen->keys()
        call add(qf, seen[k])
    endfor
    let qf = qf->sort("fixquick#sort#cmp_retain_qforder")
    call setqflist(qf)
    echo "Reduced qf by " (n_entries - len(qf))
endf
