vim-oldfiles
============

Improve Vim's native recent file history.

Motivation
----------

Vim natively keeps a list of your file history in the `v:oldfiles` variable
which you can see with the `:oldfiles` command or, even better, with `:browse
oldfiles`. Unfortunately, `:oldfiles` has two significant drawbacks:

1. The output of the command takes up the entire screen and uses Vim's
   inelegant "more prompt".
2. The list of recent files is not updated as you use Vim, and is only
   re-written when you close Vim. One can get around this with the use of the
   `:wviminfo` and `:rviminfo` commands, but this is cumbersome and not very
   intuitive.

This plugin enhances Vim's native capability by addressing these two problems.
The command `:Oldfiles` uses `:oldfiles` under the hood, but presents a list of
your recently visited files in the quickfix list. Once in the quickfix list,
you can use all of the standard tools to navigate and search through your list
of recent files (e.g. `:clist`, `:cc`, `:Cfilter`, and so on). **vim-oldfiles**
will also automatically filter non-existent and unreadable files from the list,
something vanilla `:oldfiles` does not do.

Further, while you can natively filter the output of `:oldfiles` using the
`:filter` command, this is a bit clunky. Instead, `:Oldfiles` (capital `O`)
lets you pass a search pattern as an optional second argument to allow easy
filtering.

Before:

```vim
:filter /pattern/ oldfiles
```

With **vim-oldfiles**:

```vim
:Oldfiles /pattern/
```

If you don't have any other conflicting user commands, this can be shortened
even further to simply `:Old` or even `:Ol`.

Most importantly, **vim-oldfiles** keeps the `v:oldfiles` variable up to date
as you use Vim, so when you open a new buffer you will see it at the top of the
`:Oldfiles` list.

Usage
-----

Use `:Oldfiles` to view your recent files in the quickfix list. You can also
use `:Oldfiles {pattern}` to only show files matching that pattern, or
`:Oldfiles! {pattern}` to only show files that do not match that pattern.

This plugin provides a `<Plug>(Oldfiles)` mapping which you can use to map the
`:Oldfiles` command like so

```vim
nmap <lhs> <Plug>(Oldfiles)
```

By default, this is mapped to `g<C-^>`.

See `:h Oldfiles` for more information.

Installation
------------

### Manual

If your version of Vim supports packages (`has('packages')` returns `1`),
simply clone this repository to `~/.vim/pack/gpanders/start/vim-oldfiles`.

Otherwise, copy the `plugin` and `doc` directories into your Vim runtime folder
(`$HOME/.vim` on macOS/Unix, `$HOME/vimfiles` on Windows) and run `:helptags
ALL` to generate help tags. Use `:help Oldfiles` to view the help docs.

### Pathogen

```console
cd ~/.vim/bundle
git clone https://github.com/gpanders/vim-oldfiles.git
```

### vim-plug

```vim
Plug 'gpanders/vim-oldfiles'
```

FAQ
---

**Q:** How can I make the oldfiles list automatically close after I select an
entry?

**A:** Add the following snippet to `~/.vim/after/ftplugin/qf.vim`:

```vim
if w:quickfix_title =~# 'Oldfiles'
    nnoremap <buffer> <CR> <CR>:cclose<CR>
endif
```

or if you prefer to keep everything in your `~/.vim/vimrc` file, use:

```vim
augroup oldfiles
    autocmd!
    autocmd FileType qf if w:quickfix_title =~# 'Oldfiles' | nnoremap <buffer> <CR> <CR>:cclose<CR> | endif
augroup END
```

See [here][explanation] for more information.

[explanation]: https://github.com/gpanders/vim-oldfiles/issues/2#issuecomment-776442884
