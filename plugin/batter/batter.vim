if exists("s:BatterLoaded")
    finish
endif

let s:BatterLoaded = 1

call batter#init#Init()
