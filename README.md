# oldfiles.vim

Improve Vim's native recent file history.

## Introduction

Vim natively keeps a list of your file history in the `v:oldfiles` variable
which you can see with the `:oldfiles` command or, even better, with `:browse
oldfiles`. Unfortunately, `:oldfiles` has a few drawbacks:

1. The output of the command takes up the entire screen and uses Vim's
   inelegant "more prompt".
2. The output of `:oldfiles` cannot be filtered or in any other way modified
3. The list of recent files is not updated as you use Vim, and is only
   re-written when you close Vim. One can get around this with the use of the
   `:wviminfo` and `:rviminfo` commands, but this is cumbersome and not very
   intuitive.

This plugin seeks to utilize Vim's native capability but make it slightly
better.  The command `:Oldfiles` uses `v:oldfiles` under the hood, but presents
a list of your recently visited files in the quickfix list. You can search,
sort, filter, and modify this buffer however you want, and simply press Enter
on a filename to go to that file.

Most importantly, oldfiles.vim keeps the `v:oldfiles` variable up to date as
you use Vim, so when you open a new buffer you will see it at the top of the
`:Oldfiles` list.

## Usage

Use `g<C-^>` in Normal mode or `:Oldfiles` to view your recent files in the
quickfix list. You can also use `:Oldfiles {pattern}` to only show files
matching that pattern, or `:Oldfiles! {pattern}` to only show files that do not
match that pattern.

See `:h Oldfiles` for more information.

## Installation

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
