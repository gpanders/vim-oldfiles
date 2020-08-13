function! s:filter(val) abort
  if !filereadable(a:val)
    return 0
  endif

  if !exists('g:oldfiles_blacklist') || type(g:oldfiles_blacklist) != type([])
    return 1
  endif

  for pat in g:oldfiles_blacklist
    if a:val =~# pat
      return 0
    endif
  endfor

  return 1
endfunction

function! oldfiles#add() abort
  " Add file to oldfiles when opened
  let fname = expand('<afile>:p')
  if empty(fname) || !filereadable(fname) || !&buflisted
    return
  endif

  let v:oldfiles = [fname] + filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

function! oldfiles#remove() abort
  " Remove file from oldfiles if it is no longer valid
  let fname = expand('<afile>:p')
  if empty(fname) || filereadable(fname)
    return
  endif

  call filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

function! oldfiles#open(bang, mods, ...) abort
  let pat = a:0 ? a:1 : '//'
  let cmd = 'filter' . (a:bang ? '! ' : ' ') . pat . ' oldfiles'
  let oldfiles = split(execute(cmd), '\n')
  call map(oldfiles, 'split(v:val, ''^\d\+\zs:\s\+'')')
  call map(oldfiles, {_, item -> {'filename': fnamemodify(item[1], ':p'), 'text': item[0], 'valid': 1}})
  call filter(oldfiles, {_, item -> s:filter(item.filename)})
  call setqflist(oldfiles)
  exe a:mods 'copen'
  let w:quickfix_title = ':Oldfiles'
endfunction
