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

  let fname = fnamemodify(fname, ':~')
  for filt in g:oldfiles_blacklist
    if fname =~ filt
      return v:false
    endif
  endfor
  return v:true
endfunction

function! oldfiles#open(bang, ...)
  let oldfiles = map(copy(v:oldfiles), { _, f -> fnamemodify(expand(f, 1), ':~') })
  if a:0
    let pattern = escape(a:1, '~')
    let oldfiles = filter(oldfiles, a:bang ?
          \ { _, val -> val !~ pattern } :
          \ { _, val -> val =~ pattern })
  elseif !a:bang
    let oldfiles = filter(oldfiles, function('s:filter'))
  endif

  let bufinfo = getbufinfo('Oldfiles')
  if !empty(bufinfo)
    " Buffer already exists
    let bufinfo = bufinfo[0]
    if !bufinfo.hidden && !empty(bufinfo.windows)
      let winnum = win_id2win(bufinfo.windows[0])
      execute winnum 'wincmd w'
    else
      execute 'botright sb ' . bufinfo.bufnr . ' | resize 10'
    endif
    %delete_
  else
    " Buffer does not exist, create it
    botright new
    setlocal buftype=nofile bufhidden=hide nobuflisted noswapfile
    nnoremap <silent> <buffer> <CR> gf<C-W>o:let @# = expand('#2')<CR>
    nnoremap <silent> <buffer> q <C-W>q
    nnoremap <silent> <buffer> R :<C-U>call <SID>refresh()<CR>
    autocmd WinLeave <buffer> hide
    10wincmd _
    execute 'silent file Oldfiles'
  endif
  let b:oldfiles = oldfiles
  put =oldfiles
  1delete_
endfunction
