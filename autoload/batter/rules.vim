if !exists('s:BatterRules')
    let s:BatterRules = {}
endif


function! batter#rules#SetRule(name, value)
    let s:BatterRules[a:name] = a:value
endfunction

function! batter#rules#DeleteRule(name)
    unlet s:BatterRules[a:name]
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

" Returns all buffers that do not match one of the defined rules
function! batter#rules#AllUnmatchedBuffers()
    let rules = values(batter#rules#GetAllRules())
    let found_files = []
    for each in s:AllBuffers()
        let found_match = 0
        for each_rule in rules
            if match(each, each_rule) != -1
                let found_match = 1
                break
            endif
        endfor
        if found_match == 0
            let found_files += [each]
        endif
    endfor
    return found_files
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

function! batter#rules#FindTabUsingRule(rule_name)
    let tabs_using_rule = []
    for i in range(1, tabpagenr('$'))
        if batter#rules#GetRuleNameForTab(i) == a:rule_name
            let tabs_using_rule += [i]
        endif
    endfor
    return tabs_using_rule
endfunction
