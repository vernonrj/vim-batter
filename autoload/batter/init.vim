function! batter#init#Init()
    command! -nargs=0 -range Batter :call batter#window#ShowBuffersForTab()
    command! -nargs=0 BatterUnmatched :call batter#window#ShowUnmatchedFiles()
    command! -nargs=? -complete=customlist,s:ListRules BatterEditRule :call batter#window#EditRule(<q-args>)
    command! -nargs=1 -complete=customlist,s:ListRules BatterTabRule :call batter#window#SetTabRule(<q-args>)
    command! -nargs=1 -complete=customlist,s:ListRules BatterDeleteRule :call batter#window#DeleteRule(<q-args>)
    command! -nargs=0 BatterSave :call batter#window#SaveFilters()
    command! -nargs=0 BatterLoad :call batter#window#LoadFilters()
endfunction

function! s:ListRules(A,L,P)
    let rules = keys(batter#rules#GetAllRules())
    let filtered = filter(rules, 'v:val =~ a:A')
    return sort(filtered)
endfunction
