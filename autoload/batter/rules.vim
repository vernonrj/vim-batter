if !exists('s:BatterRules')
    let s:BatterRules = {}
endif


function! batter#rules#SetRule(name, value)
    let s:BatterRules[a:name] = a:value
endfunction

function! batter#rules#GetRule(name)
    if !exists('s:BatterRules[a:name]')
        return ""
    else
        return s:BatterRules[a:name]
    endif
endfunction

function! batter#rules#GetAllRules()
    return s:BatterRules
endfunction

function! s:AllBuffers()
    let buffers_we_care_about = []
    for b in range(1, bufnr("$"))
        if bufexists(b) && (!empty(getbufvar(b, "&buftype")) || filereadable(bufname(b)))
            let buffers_we_care_about += [bufname(b)]
        endif
    endfor
    return buffers_we_care_about
endfunction

function! batter#rules#FilterBuffersWithRule(name)
    if !exists('s:BatterRules[a:name]')
        return []
    else
        let current_filter = batter#rules#GetRule(a:name)
        let found_files = []
        for each in s:AllBuffers()
            if match(each, current_filter) != -1
                let found_files += [each]
            endif
        endfor
        return found_files
    endif
endfunction

function! batter#rules#SetRuleNameForTab(tab_number, rule_name)
    if !exists('s:BatterRules[a:rule_name]')
        echoerr "Rule '" . a:rule_name . "' doesn't exist!"
    else
        call settabvar(a:tab_number, "BatterFilterForThisTab", a:rule_name)
    endif
endfunction

function! batter#rules#GetRuleNameForTab(tab_number)
    return gettabvar(a:tab_number, "BatterFilterForThisTab")
endfunction