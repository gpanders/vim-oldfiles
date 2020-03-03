function! oldfiles#add()
  " Add file to oldfiles when opened
  let fname = expand("<afile>:p")
  if empty(fname) || !filereadable(fname) || !&buflisted
    return
  endif

  let v:oldfiles = [fname] + filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

function! oldfiles#remove()
  " Remove file from oldfiles if it is no longer valid
  let fname = expand("<afile>:p")
  if empty(fname) || filereadable(fname)
    return
  endif

  call filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

function! oldfiles#open(bang, ...)
  let cmd = 'filter' . (a:bang ? '! ' : ' ') . (a:0 ? a:1 : '//') . ' oldfiles'
  let oldfiles = filter(map(split(execute(cmd), '\n'),
              \ 'fnamemodify(split(v:val, ''^\d\+:\s\+'')[0], '':p'')'),
              \ 'filereadable(v:val)')
  let items = map(oldfiles, {i, file -> {'filename': file, 'text': i+1, 'valid': 1}})
  call setqflist(items)
  copen
  let w:quickfix_title = ':Oldfiles'
endfunction
