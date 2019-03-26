function! s:refresh()
  let l = getline('.')
  let c = col('.')
  %delete_
  put =b:oldfiles
  1delete_
  normal! gg0
  call search(escape('^' . l . '$', '.~'), 'c', '$')
  execute 'normal! ' . c . '|'
endfunction

function! s:filter(_, val)
  let fname = expand(a:val, !g:oldfiles_use_wildignore)
  if empty(fname)
    return v:false
  endif

  if g:oldfiles_ignore_unreadable && !filereadable(fname)
    return v:false
  endif

  for filt in g:oldfiles_blacklist
    if fname =~ filt
      return v:false
    endif
  endfor
  return v:true
endfunction

function! oldfiles#open(bang, ...)
  let oldfiles = copy(v:oldfiles)
  if a:0 > 0
    let pattern = a:1
    let oldfiles = filter(oldfiles, a:bang ?
          \ { _, val -> val !~ pattern } :
          \ { _, val -> val =~ pattern })
  elseif !a:bang
    let oldfiles = filter(oldfiles, function('s:filter'))
  endif

  call map(oldfiles, { _, f -> fnamemodify(expand(f), ':~') })
  let winnum = bufwinnr('Oldfiles')
  if winnum != -1
    " Buffer already exists
    execute winnum 'wincmd w'
    %delete_
  else
    " Buffer does not exist, create it
    new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    nnoremap <silent> <buffer> <CR> gf<C-W>o
    nnoremap <silent> <buffer> q <C-W>q
    nnoremap <silent> <buffer> R :<C-U>call <SID>refresh()<CR>
    10wincmd _
    execute 'silent file Oldfiles'
  endif
  let b:oldfiles = oldfiles
  put =oldfiles
  1delete_
endfunction
