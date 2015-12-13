let s:pluginBuffer = -1

function! batter#window#CreateNewPluginWindow()

    let old_efm = &errorformat
    set errorformat=%f
    lgetexpr batter#buffers#GetBuffersForTab(tabpagenr())
    let &errorformat = old_efm
    lopen

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
    setlocal noswapfile

	setlocal filetype=batter

    let s:pluginBuffer = bufnr("%")

    let current_filter = batter#buffers#GetFilterForTab(tabpagenr())
    let current_exprs = current_filter.private.patterns

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

function! batter#window#SaveFilters()
    let filters = {}
    for t in range(1, tabpagenr('$'))
        if batter#buffers#IsFilterDefinedForTab(t)
            let filters[t] = batter#buffers#GetFilterForTab(t).private
        endif
    endfor
    let g:Batter_session = webapi#json#encode(filters)
endfunction

function! batter#window#LoadFilters()
    if !exists('g:Batter_session')
        return
    endif
    for [key, value] in items(webapi#json#decode(g:Batter_session))
        let f = batter#filter#DefaultFilter()
        let f.private = value
        call batter#buffers#SetFilterForTab(key, f)
    endfor

endfunction
