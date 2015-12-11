if exists("s:BatterLoaded")
    finish
endif

let s:BatterLoaded = 1


augroup batter
    autocmd SessionLoadPost * call batter#window#LoadFilters()
augroup END


call batter#init#Init()
