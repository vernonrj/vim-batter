function! batter#init#Init()
    command! -nargs=0 -range Batter :call batter#window#TogglePluginWindow()
    command! -nargs=0 -range BatterEdit :call batter#window#EditFilterViaWindow()
endfunction
