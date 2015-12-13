function! s:FilterPrivate()
    let f = {"_apply_method": "AND",
           \ "patterns": []}
    return f
endfunction

function! batter#filter#DefaultFilter()
    let f = {'private': s:FilterPrivate()}
    function f.add_pattern(new_pattern)
        let self.private.patterns += [a:new_pattern]
    endfunction
    function f.set_patterns(new_patterns)
        let self.private.patterns = a:new_patterns
    endfunction
    function f.apply_patterns_to(list_of_files)
        if len(self.private.patterns) == 0
            return a:list_of_files
        else
            let filtered_files = []
            for each in a:list_of_files
                let matches = 1
                for each_pattern in self.private.patterns
                    if match(each, each_pattern) == -1
                        let matches = 0
                        break
                    endif
                endfor
                if matches == 1
                    let filtered_files += [each]
                endif
            endfor
            return filtered_files
        endif
    endfunction
    return f
endfunction

