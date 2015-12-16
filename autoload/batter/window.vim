
function! batter#window#ShowBuffersForTab()

    let old_efm = &errorformat
    set errorformat=%f
    lgetexpr batter#rules#FilterBuffersWithRule(batter#rules#GetRuleNameForTab(tabpagenr()))
    let &errorformat = old_efm
    lopen

endfunction

function! batter#window#ShowUnmatchedFiles()
    let old_efm = &errorformat
    set errorformat=%f
    lgetexpr batter#rules#AllUnmatchedBuffers()
    let &errorformat = old_efm
    lopen
endfunction

function! batter#window#EditRule(rulename)
    let value = batter#rules#GetRule(a:rulename)
    if empty(value)
        let value = a:rulename
    endif
    call inputsave()
        echohl Question
            let value = input('Input pattern to match: ', value)
        echohl None
    call inputrestore()
    if empty(value)
        return 0
    endif
    call batter#rules#SetRule(a:rulename, value)
    if empty(batter#rules#GetRuleNameForTab(tabpagenr()))
        call batter#rules#SetRuleNameForTab(tabpagenr(), a:rulename)
    endif
endfunction

function! batter#window#SetTabRule(rulename)
    call batter#rules#SetRuleNameForTab(tabpagenr(), a:rulename)
endfunction

function! batter#window#SaveFilters()
    let tab_assocs = {}
    for t in range(1, tabpagenr('$'))
        if batter#rules#GetRuleNameForTab(t) != ""
            let tab_assocs[t] = batter#rules#GetRuleNameForTab(t)
        endif
    endfor
    let g:Batter_session = webapi#json#encode(
                \ {
                    \ "rules": batter#rules#GetAllRules(),
                    \ "assocs": tab_assocs
                \ })
endfunction

function! batter#window#LoadFilters()
    if !exists('g:Batter_session')
        return
    endif
    let session = webapi#json#decode(g:Batter_session)
    for [rule_name, rule_value] in items(session["rules"])
        call batter#rules#SetRule(rule_name, rule_value)
    endfor
    for [tab_nr, rule_name] in items(session["assocs"])
        call batter#rules#SetRuleNameForTab(tab_nr, rule_name)
    endfor

endfunction
