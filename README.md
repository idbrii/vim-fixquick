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


# Helper functions

## Sort By Buffers

`call fixquick#sort#sort_by_buffers()` to rearrange the quickfix:

* errors first
* buffers you've explicitly opened ('buflisted')

It will also maintain the order of buffers that don't have an associated
file, so if you log your compile command and a timestamp on completion,
those will stay at the beginning and end.

Useful when you have a legacy project with a lot of warnings and you're trying
to sift through to fix the issues you're introducing first.

You can make this behaviour automatic with an autocmd:

    au QuickfixCmdPost make call fixquick#sort#sort_by_buffers()

If you use an async make plugin like
[asyncrun.vim](https://github.com/skywind3000/asyncrun.vim), you can instead
configure it to apply this sort only when the build completes:

    let g:asyncrun_exit = 'call fixquick#sort#sort_by_buffers()'


## Resize Quickfix To Error Count

`call fixquick#window#resize_qf_to_errorcount(minheight, maxheight)` to resize
the quickfix to match the number of errors.

If 'errorformat' doesn't use `%t` (parse the type of error), then it includes all
entries with corresponding files as errors.

You can make this behaviour automatic with an autocmd:

    au QuickfixCmdPost make call fixquick#window#resize_qf_to_errorcount(3, 20)


## `:copen` Without Moving Cursor

`fixquick#window#copen_without_moving_cursor()` opens the quickfix window but
keeps the cursor at its current location.

If you only want the quickfix open if it contains entries, you can append
`:cwindow`:

    call fixquick#window#copen_without_moving_cursor() | cwindow


## Show Last Error Without Jump

Set the selected entry (and view it in the quickfix window) to be the last
entry in the quickfix.

`fixquick#window#show_last_error_without_jump()`
