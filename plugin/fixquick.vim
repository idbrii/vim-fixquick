" fixquick - utilities for the quickfix


nnoremap <silent> <Plug>(fixquick-toggle-quickfix) <Cmd>call fixquick#window#quick_fix_toggle('c')<CR>
nnoremap <silent> <Plug>(fixquick-toggle-locationlist) <Cmd>call fixquick#window#quick_fix_toggle('l')<CR>
nnoremap <silent> <Plug>(fixquick-toggle-preview) <Cmd>call fixquick#window#preview_toggle()<CR>

" Make it easier to turn these off in case I'm troubleshooting mappings.
if (! exists('no_plugin_maps') || ! no_plugin_maps) &&
      \ (! exists('no_fixquick_maps') || ! no_fixquick_maps)
    nmap <unique> <Leader>we <Plug>(fixquick-toggle-quickfix)
    nmap <unique> <Leader>wE <Plug>(fixquick-toggle-locationlist)
    nmap <unique> <Leader>wP <Plug>(fixquick-toggle-preview)
endif
