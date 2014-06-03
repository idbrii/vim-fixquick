vim-fixquick
============

Minor improvements to the quickfix.

Adds global maps:

    <Leader>wq <Plug>(fixquick-toggle-quickfix)
    <Leader>wl <Plug>(fixquick-toggle-locationlist)

And quickfix maps:

    " Traversing the quickfix timeline.
    <A-Left>  :colder<CR>
    <A-Right> :cnewer<CR>

    " Easy quit.
    q :close<CR>

