if (! exists('no_plugin_maps') || ! no_plugin_maps) &&
            \ (! exists('no_fixquick_maps') || ! no_fixquick_maps)

    " If there isn't already one, we'll do the wrong thing.
    if exists(b:undo_ftplugin)
        for mapkey in ["q", "<A-Left>", "<A-Right>"]
            let b:undo_ftplugin .= " | nunmap <buffer> ". mapkey
        endfor
    endif


    " Similar to mapping bp/bn: traversing quickfix "buffers".
    nnoremap <buffer> <A-Left>  :colder<CR>
    nnoremap <buffer> <A-Right> :cnewer<CR>

    " Easy quit.
    nnoremap <silent> <buffer> q :close<CR>
endif
