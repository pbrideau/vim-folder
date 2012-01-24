""""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTION TO COMPLEMENT MATCHIT FOR XML HTML TAG SHOW
fun! s:HiMatch()
    if !exists('b:match_words')
        return
    endif
    let wsv = winsaveview()
    let lcs = []
    while 1
        exe 'normal %'
        let lc = {'line': line('.'), 'col': col('.')}
        if len(lcs) > 0 && lc.line == lcs[0].line && lc.col == lcs[0].col
            break
        endif
        call add(lcs, lc)
    endwhile
    if len(lcs) > 1
        let lcre = ''
        call map(lcs, '"\\%" . v:val.line . "l\\%" . v:val.col . "c"')
        let lcre = join(lcs, '\|')
        let mw = split(b:match_words, ',\|:')
        let mw = filter(mw, 'v:val !~ "^[(){}[\\]]$"')
        let mwre = '\%(' . join(mw, '\|') . '\)'
        let mwre = substitute(mwre, "'", "''", 'g')
        " final \& part of the regexp is a hack to improve html
        exe 'match cursorline ''.*\%(' . lcre . '\).*\&' . mwre . '\&\%(<\_[^>]\+>\|.*\)'''
    else
        match none
    endif
    call winrestview(wsv)
endfun
com! HiMatch call s:HiMatch()
com! HiMatchOn augroup my_matchit|exe'au!'|exe 'au cursormoved * HiMatch'|augroup END|doautocmd my_matchit cursormoved
com! HiMatchOff augroup my_matchit|exe'au!'|augroup END|match none
