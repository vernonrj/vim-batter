function! batter#init#Init()
    command! -nargs=0 -range Batter :call batter#window#TogglePluginWindow()
    command! -nargs=0 BatterSave :call batter#window#SaveFilters()
    command! -nargs=0 BatterLoad :call batter#window#LoadFilters()
endfunction
