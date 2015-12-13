function! batter#buffers#GetBuffersForTab(tabnr)
    if a:tabnr
        let filter_for_tab = batter#buffers#GetFilterForTab(a:tabnr)
        let buffers_for_tab = []
        for b in range(1, bufnr("$"))
            if bufexists(b) && (!empty(getbufvar(b, "&buftype")) || filereadable(bufname(b)))
                let buffers_for_tab += [bufname(b)]
            endif
        endfor
        return filter_for_tab.apply_patterns_to(buffers_for_tab)
    else
        return []
    endif
endfunction

" Returns a dictionary describing the filtering method for this tab
function! batter#buffers#GetFilterForTab(tabnr)
    if !batter#buffers#IsFilterDefinedForTab(a:tabnr)
        let filter_for_tab = batter#filter#DefaultFilter()
        call batter#buffers#SetFilterForTab(a:tabnr, filter_for_tab)
    else
        let filter_for_tab = gettabvar(a:tabnr, "BatterFilterForThisTab")
    endif
    return filter_for_tab
endfunction

function! batter#buffers#SetFilterForTab(tabnr, new_filter)
    call settabvar(a:tabnr, "BatterFilterForThisTab", a:new_filter)
endfunction

function! batter#buffers#IsFilterDefinedForTab(tabnr)
    let filter_for_tab = gettabvar(a:tabnr, "BatterFilterForThisTab")
    if type(filter_for_tab) != 4
        return 0
    else
        return 1
    endif
endfunction

function! batter#buffers#SetRegexForTab(tabnr, expression)
    let filter_for_tab = batter#buffers#GetFilterForTab(a:tabnr)
    call filter_for_tab.add_pattern(a:expression)
    call batter#buffers#SetFilterForTab(a:tabnr, filter_for_tab)
endfunction
