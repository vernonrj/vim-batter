function! batter#init#Init()
    command! -nargs=0 -range Batter :call batter#window#ShowBuffersForTab()
    command! -nargs=0 BatterUnmatched :call batter#window#ShowUnmatchedFiles()
    command! -nargs=1 BatterEditRule :call batter#window#EditRule(<q-args>)
    command! -nargs=1 BatterTabRule :call batter#window#SetTabRule(<q-args>)
    command! -nargs=0 BatterSave :call batter#window#SaveFilters()
    command! -nargs=0 BatterLoad :call batter#window#LoadFilters()
endfunction
