" Quickly open/close quickfix
"
" I haven't figured out how to just toggle, but this is the closest. If we're
" in the quickfix/locationlist, close it. Otherwise open it.
function! s:QuickFixToggle(prefix)
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
    endif
endfunction

function! s:SplitIfNecessaryAndJump()

    try
        .cc
    catch /^Vim\%((\a\+)\)\=:E37/	" No write since last change
        " Theoretically equivalent to: execute "normal! \<C-w>\<CR>"
        " But that doesn't work.
        split
        wincmd p
        .cc
    endtry
endf

function! s:PreviewToggle()
    if &previewwindow
        " If we're already in a preview window, then close it.
        pclose
    else
        " If we're not in a preview window, try to open it.
        wincmd P
    endif
endf


nnoremap <silent> <Plug>(fixquick-toggle-quickfix) :call <SID>QuickFixToggle('c')<CR>
nnoremap <silent> <Plug>(fixquick-toggle-locationlist) :call <SID>QuickFixToggle('l')<CR>
nnoremap <silent> <Plug>(fixquick-toggle-preview) :call <SID>PreviewToggle()<CR>

nnoremap <silent> <Plug>(fixquick-jump-to-selected) :call <SID>SplitIfNecessaryAndJump()<CR>

" Make it easier to turn these off in case I'm troubleshooting mappings.
if (! exists('no_plugin_maps') || ! no_plugin_maps) &&
      \ (! exists('no_fixquick_maps') || ! no_fixquick_maps)
    nmap <unique> <Leader>we <Plug>(fixquick-toggle-quickfix)
    nmap <unique> <Leader>wE <Plug>(fixquick-toggle-locationlist)
    nmap <unique> <Leader>wP <Plug>(fixquick-toggle-preview)
endif
