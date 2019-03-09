" oldfiles.vim
" Populate the output of :oldfiles into a separate buffer
" Author: Greg Anders <greg@gpanders.com>
" License: Same as vim itself

if exists('g:loaded_oldfiles')
  finish
endif
let g:loaded_oldfiles = 1

if !exists('g:oldfiles_blacklist')
  let g:oldfiles_blacklist = []
endif

let g:oldfiles_ignore_unreadable = get(g:, 'oldfiles_ignore_unreadable', 1)
let g:oldfiles_use_wildignore = get(g:, 'oldfiles_use_wildignore', 1)

function! s:update()
  let fname = expand('%:p:~')
  let idx = index(v:oldfiles, fname)
  if idx > -1
    call remove(v:oldfiles, idx)
  endif
  call insert(v:oldfiles, fname)
endfunction

function! s:filter(_, val)
  let fname = expand(a:val, !g:oldfiles_use_wildignore)
  if empty(fname)
    return v:false
  endif

  if !filereadable(fname) && g:oldfiles_ignore_unreadable
    return v:false
  endif

  for filt in g:oldfiles_blacklist
    if fname =~# filt
      return v:false
    endif
  endfor
  return v:true
endfunction

function! <SID>refresh()
  let l = getline('.')
  let c = col('.')
  %delete_
  put =b:oldfiles
  1delete_
  normal! gg0
  call search(escape('^' . l . '$', '.~'), 'c', '$')
  execute 'normal! ' . c . '|'
endfunction

function! s:oldfiles()
  let oldfiles = filter(copy(v:oldfiles), function('s:filter'))
  call map(oldfiles, { _, f -> fnamemodify(expand(f), ':~') })
  new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  let b:oldfiles = oldfiles
  10wincmd _
  nnoremap <silent> <buffer> <CR> gf<C-W>o
  nnoremap <silent> <buffer> q <C-W>q
  nnoremap <silent> <buffer> R :<C-U>call <SID>refresh()<CR>
  put =oldfiles
  1delete_
  execute 'silent file Oldfiles'
endfunction

augroup oldfiles.vim
  autocmd!
  autocmd BufRead * call s:update()
augroup END

command! -nargs=0 Oldfiles call s:oldfiles()
