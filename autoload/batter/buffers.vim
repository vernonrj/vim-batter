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
    " return filter(buffers_for_tab, "buflisted(str2nr(v:key))")
endfunction

" Returns a dictionary describing the filtering method for this tab
function! batter#buffers#GetFilterForTab(tabnr)
    let filter_for_tab = gettabvar(a:tabnr, "BatterFilterForThisTab")
    if type(filter_for_tab) != 4
        unlet filter_for_tab
        let filter_for_tab = batter#filter#DefaultFilter()
        call settabvar(a:tabnr, "BatterFilterForThisTab", filter_for_tab)
    endif
    return filter_for_tab
endfunction
