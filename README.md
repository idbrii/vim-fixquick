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
    gq :close<CR>


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


## Remove duplicate file+line+col entries from Quickfix

`call fixquick#sort#remove_multiple_for_same_position()` to remove quickfix entries
that are for the same file, line, and column.


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


## Show First/Last Error Without Jump

Select the first/last entry in the quickfix -- it will be visible in the
quickfix and `:cnext` will jump to the following error. 

Showing the first error is useful when you have a bunch of preamble before your
errors show up.

Showing the last error is useful for languages like Python where stacktraces
have the most relevant locations at the bottom. Or if you're loading a log file
into the quickfix and want to inspect the last message/callstack first.

    fixquick#window#show_first_error_without_jump()
    fixquick#window#show_last_error_without_jump()


## Show Next or Current Error

It's useful to have mappings to show next error, but "E553: No more items"
often isn't helpful -- you still want to jump to something. Use `jump_to_next`
to you jump to next and jump to the last item when navigating past the end of
the list.

    nnoremap <silent> <C-PageDown> :call fixquick#window#jump_to_next(1)<CR>
    nnoremap <silent> <C-PageUp>   :call fixquick#window#jump_to_next(-1)<CR>

Similar to mapping to `:cc<Bar>cnext<CR>`, but you jump at most once so your
current window remains the target for the jump.


# Tips

I'd recommend finding mappings for both `:cnext` `:cnfile` and their analogs.
This makes it easy to both jump through the error list and skip over files
(like when cpp compilers report errors on every line after the first real
error).

I use PageUp/Down:

    " Ctrl+PgUp/Dn - Move between quickfix marks. Jump to current first to
    " ensure we always jump to something.
    nnoremap <silent> <C-PageDown> :call fixquick#window#jump_to_next(1)<CR>
    nnoremap <silent> <C-PageUp>   :call fixquick#window#jump_to_next(-1)<CR>
    " Alt+PgUp/Dn - Move between quickfix files
    nnoremap <A-PageDown> :cnfile<CR>
    nnoremap <A-PageUp> :cpfile<CR>
    " Ctrl+Alt+PgUp/Dn - Move between location window marks
    nnoremap <C-A-PageDown> :lnext<CR>
    nnoremap <C-A-PageUp> :lprev<CR>
    " Ctrl+Shift+PgUp/Dn - Move between files
    nnoremap <C-S-PageDown> :next<CR>
    nnoremap <C-S-PageUp> :prev<CR>

You could also use [vim-unimpaired](https://github.com/tpope/vim-unimpaired).
