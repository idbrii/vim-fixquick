if !exists("b:fixquick_prefix")
    if get(getloclist(0, {'winid':0}), 'winid', 0) == win_getid()
        let b:fixquick_prefix = 'l'
    else
        let b:fixquick_prefix = 'c'
    endif
endif

if (! exists('no_plugin_maps') || ! no_plugin_maps) &&
            \ (! exists('no_fixquick_maps') || ! no_fixquick_maps)

    " If there isn't already one, we'll do the wrong thing.
    if exists(b:undo_ftplugin)
        for mapkey in ["<CR>", "<A-Left>", "<A-Right>", "gq"]
            let b:undo_ftplugin .= " | nunmap <buffer> ". mapkey
        endfor
    endif

    " A do-what-I-mean jump to selected: open in new window instead of error.
    nmap <buffer> <CR> <Plug>(fixquick-jump-to-selected)

    " Similar to mapping bp/bn: traversing quickfix "buffers".
    exec 'nnoremap <buffer> <A-Left>  :'. b:fixquick_prefix .'older<CR>'
    exec 'nnoremap <buffer> <A-Right> :'. b:fixquick_prefix .'newer<CR>'

    " Easy quit.
    nnoremap <silent> <buffer> gq :close<CR>
endif
