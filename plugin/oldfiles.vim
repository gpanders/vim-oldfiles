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

augroup oldfiles.vim
  autocmd!
  autocmd BufRead * call s:update()
augroup END

command! -nargs=? -bang Oldfiles call oldfiles#open(<bang>0, <f-args>)
