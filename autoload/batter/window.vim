let s:pluginBuffer = -1

function! batter#window#CreateNewPluginWindow()

    let old_efm = &errorformat
    set errorformat=%f
    lgetexpr batter#rules#FilterBuffersWithRule(batter#rules#GetRuleNameForTab(tabpagenr()))
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
