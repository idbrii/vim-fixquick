function! s:cmp(left, right) abort
    if a:left == a:right
        return 0
    elseif a:left < a:right
        return -1
    elseif a:left > a:right
        return 1
    endif
endf

function! fixquick#sort#compare_qf_entries(left, right) abort
    if a:left.bufnr == 0 || a:right.bufnr == 0
        " Maintain order for unlisted
        return s:cmp(a:left.qforder, a:right.qforder)
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
    let qf = qf->sort("fixquick#sort#compare_qf_entries")
    call setqflist(qf)
endf
