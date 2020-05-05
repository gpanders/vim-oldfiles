function! oldfiles#add()
  " Add file to oldfiles when opened
  let fname = expand('<afile>:p')
  if empty(fname) || !filereadable(fname) || !&buflisted
    return
  endif

  let v:oldfiles = [fname] + filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

function! oldfiles#remove()
  " Remove file from oldfiles if it is no longer valid
  let fname = expand('<afile>:p')
  if empty(fname) || filereadable(fname)
    return
  endif

  call filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

function! s:filter(val)
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

function! oldfiles#open(bang, mods, ...) abort
  let pat = a:0 ? a:1 : '//'
  let cmd = 'filter' . (a:bang ? '! ' : ' ') . pat . ' oldfiles'
  let oldfiles = filter(map(split(execute(cmd), '\n'),
              \ 'fnamemodify(split(v:val, ''^\d\+:\s\+'')[0], '':p'')'),
              \ 's:filter(v:val)')
  let items = map(oldfiles, {i, file -> {'filename': file, 'text': i+1, 'valid': 1}})
  call setqflist(items)
  exe a:mods . ' copen'
  let w:quickfix_title = ':Oldfiles'
endfunction
