" oldfiles.vim
" Populate the output of :oldfiles into the quickfix list
" Author: Greg Anders <greg@gpanders.com>
" License: Same as vim itself

if exists('g:loaded_oldfiles')
  finish
endif
let g:loaded_oldfiles = 1

function! s:add()
  " Add file to oldfiles when opened
  let fname = expand("<afile>:p")
  if empty(fname) || !filereadable(fname) || !&buflisted
    return
  endif

  let v:oldfiles = [fname] + filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

function! s:remove()
  " Remove file from oldfiles if it is no longer valid
  let fname = expand("<afile>:p")
  if empty(fname) || filereadable(fname)
    return
  endif

  call filter(v:oldfiles, {_, f -> f !=# fname})
endfunction

augroup oldfiles.vim
  autocmd!
  autocmd BufWinEnter * call s:add()
  autocmd BufDelete * call s:remove()
augroup END

nnoremap <silent> <Plug>(Oldfiles) :<C-U>call oldfiles#open(0)<CR>
command! -nargs=? -bang Oldfiles call oldfiles#open(<bang>0, <f-args>)

if !mapcheck("g<C-^>", "n")
  nmap g<C-^> <Plug>(Oldfiles)
endif
