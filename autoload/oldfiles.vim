function! oldfiles#open(bang, ...)
  let pattern = a:0 ? a:1 : ''
  let oldfiles = filter(copy(v:oldfiles),
        \ {_, file -> filereadable(file) && (a:bang ? file !~# pattern : file =~# pattern)})
  let items = map(oldfiles, {i, file -> {'filename': file, 'text': i+1}})
  call setqflist(items)
  copen
  let w:quickfix_title = ':Oldfiles'
endfunction
