" recentf.vim
" Populate the output of :oldfiles into a separate buffer
" Author: Greg Anders <greg@gpanders.com>
" License: Same as vim itself

if exists('g:loaded_recentf')
  finish
endif
let g:loaded_recentf = 1

if !exists('g:recentf_blacklist')
  let g:recentf_blacklist = []
endif

let g:recentf_ignore_unreadable = get(g:, 'recentf_ignore_unreadable', 1)
let g:recentf_use_wildignore = get(g:, 'recentf_use_wildignore', 1)

function! s:update()
  let fname = expand('%:p:~')
  let idx = index(v:oldfiles, fname)
  if idx > -1
    call remove(v:oldfiles, idx)
  endif
  call insert(v:oldfiles, fname)
endfunction

function! s:filter(_, val)
  let fname = expand(a:val, !g:recentf_use_wildignore)
  if empty(fname)
    return v:false
  endif

  if !filereadable(fname) && g:recentf_ignore_unreadable
    return v:false
  endif

  for filt in g:recentf_blacklist
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
  put =b:recentf
  1delete_
  normal! gg0
  call search(escape('^' . l . '$', '.~'), 'c', '$')
  execute 'normal! ' . c . '|'
endfunction

function! s:recentf()
  let recentf = filter(copy(v:oldfiles), function('s:filter'))
  call map(recentf, { _, f -> fnamemodify(expand(f), ':~') })
  new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  let b:recentf = recentf
  10wincmd _
  nnoremap <silent> <buffer> <CR> gf<C-W>o
  nnoremap <silent> <buffer> q <C-W>q
  nnoremap <silent> <buffer> R :<C-U>call <SID>refresh()<CR>
  put =recentf
  1delete_
  execute 'silent file Recent Files'
endfunction

augroup recentf
  autocmd!
  autocmd BufRead * call s:update()
augroup END

command! -nargs=0 Recentf call s:recentf()
