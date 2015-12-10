let s:pluginBuffer = -1

function! batter#window#CreateNewPluginWindow()
    silent! exe "noautocmd botright pedit Batter"
    silent! exe "noautocmd wincmd P"
    silent! exe "resize" (&lines / 3)

	setlocal noswapfile
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal nobuflisted
	setlocal nomodifiable
	setlocal nowrap
	setlocal nonumber
	if exists('+relativenumber')
		setlocal norelativenumber
	endif
	setlocal nocursorcolumn
	setlocal nocursorline
	setlocal nospell
	setlocal nolist
	setlocal cc=
	setlocal filetype=batter

    let s:pluginBuffer = bufnr("%")

    let b:text = batter#buffers#GetBuffersForTab(tabpagenr())

    setlocal modifiable

    if len(b:text) > 0
        silent! put! =b:text
        normal! Gkj
    endif

    setlocal nomodifiable

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
