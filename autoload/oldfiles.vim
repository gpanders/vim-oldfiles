function! s:filter(file, bang, pat)
  if !filereadable(a:file)
    return 0
  endif

  if !empty(a:pat) && (a:bang ? a:file =~# a:pat : a:file !~# a:pat)
    return 0
  endif

  return 1
endfunction

function! oldfiles#open(bang, ...)
  let pat = a:0 ? a:1 : ''
  let oldfiles = filter(map(copy(v:oldfiles),
        \ 'simplify(expand(v:val))'), 's:filter(v:val, a:bang, pat)')
  let items = map(oldfiles, {i, file -> {'filename': file, 'text': i+1}})
  call setqflist(items)
  copen
  let w:quickfix_title = ':Oldfiles'
endfunction
