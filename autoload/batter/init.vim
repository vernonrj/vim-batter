function! batter#init#Init()
    command! -nargs=0 -range Batter :call batter#window#TogglePluginWindow()
endfunction
