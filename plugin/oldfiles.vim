" oldfiles.vim
" Populate the output of :oldfiles into the quickfix list
" Author: Greg Anders <greg@gpanders.com>
" License: Same as vim itself

if exists('g:loaded_oldfiles')
  finish
endif
let g:loaded_oldfiles = 1

augroup oldfiles.vim
  autocmd!
  autocmd BufWinEnter * call oldfiles#add()
  autocmd BufDelete * call oldfiles#remove()
augroup END

nnoremap <silent> <Plug>(Oldfiles) :<C-U>call oldfiles#open(0)<CR>
command! -nargs=? -bang Oldfiles call oldfiles#open(<bang>0, <f-args>)

if !hasmapto('<Plug>(Oldfiles)', 'n') && mapcheck('g<C-^>', 'n') == ''
  nmap g<C-^> <Plug>(Oldfiles)
endif
