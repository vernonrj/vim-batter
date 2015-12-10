let s:pluginBuffer = -1

function! batter#window#CreateNewPluginWindow()

    let old_efm = &errorformat
    set errorformat=%f
    cgetexpr batter#buffers#GetBuffersForTab(tabpagenr())
    let &errorformat = old_efm
    copen

endfunction

function! batter#window#TogglePluginWindow()
    if batter#window#IsPluginWindowOpen()
        call batter#window#ClosePluginWindow()
    else
        call batter#window#CreateNewPluginWindow()
    endif
endfunction

function! batter#window#IsPluginWindowOpen()
    return bufexists(s:pluginBuffer) && bufwinnr(s:pluginBuffer) != -1
endfunction

function! batter#window#EditFilterViaWindow()

    if bufexists('BatterRegex')
        bdelete! BatterRegex
    endif

    silent! exe "noautocmd botright pedit BatterRegex"
    silent! exe "noautocmd wincmd P"
    silent! exe "resize" (&lines / 3)
    setlocal modifiable noreadonly

	setlocal filetype=batter

    let s:pluginBuffer = bufnr("%")

    let current_filter = batter#buffers#GetFilterForTab(tabpagenr())
    let current_exprs = current_filter.patterns

    if len(current_exprs) > 0
        silent! put! =current_exprs
        normal! Gkj
    endif
    setlocal nomodified

    augroup BatterEditFilter
        autocmd!
        autocmd BufWriteCmd <buffer> nested :call s:WriteNewFilters(bufnr("%"))
    augroup END

endfunction

function! s:WriteNewFilters(buffer_number)
    let contents = getbufline(a:buffer_number, 1, "$")
    let current_filter = batter#buffers#GetFilterForTab(tabpagenr())
    call current_filter.set_patterns(contents)
    setlocal nomodified
    call batter#buffers#SetFilterForTab(tabpagenr(), current_filter)
endfunction
