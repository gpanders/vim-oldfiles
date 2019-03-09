# oldfiles.vim

Improve Vim's native recent file history.

## Introduction

Vim natively keeps a list of your file history in the `v:oldfiles` variable
which you can see with the `:oldfiles` command or, even better, with `:browse
oldfiles`. Unfortunately, `:oldfiles` has a few drawbacks:

1. The output of the command takes up the entire screen and uses Vim's inelegant
   "more prompt".
2. The output of :oldfiles cannot be filtered or in any other way modified
3. The list of recent files is not updated as you use Vim, and is only
   re-written when you close Vim. One can get around this with the use of the
   `:wviminfo` and `:rviminfo` commands, but this is cumbersome and not very
   intuitive.

This plugin seeks to utilize Vim's native capability but make it slightly
better.  The command `:Oldfiles` uses `v:oldfiles` under the hood, but presents
a list of your recently visited files in a separate buffer. You can search,
sort, filter, and modify this buffer however you want, and simply press Enter on
a filename to go to that file.

Oldfiles.vim also allows you to filter the output of `:oldfiles`. For example,
you can filter out Vim help docs, Git commit message files, or anything else
that you don't want to populate the recent files list.

Most importantly, Oldfiles.vim keeps the `v:oldfiles` variable up to date as you
use Vim, so when you open a new buffer you will see it at the top of your recent
files list.

## Usage

Use `:Oldfiles` to view your recent files in a new buffer. Press `Enter` on a
file name to visit that file, `R` to reload the buffer, and `q` to close the
buffer.

Other than the mappings listed above, the Oldfiles buffer is just a normal Vim
buffer, so all other Vim commands work as expected.

## Installation

### Manual

Copy the `plugin` and `doc` directories into your Vim runtime folder
(`$HOME/.vim` on macOS/Unix, `$HOME/vimfiles` on Windows) and run `:helptags
ALL` to generate help tags. Use `:help recentf` to view the help docs.

### Pathogen

```shell
cd ~/.vim/bundle
git clone https://github.com/gpanders/vim-oldfiles.git
```

### vim-plug

```vim
Plug 'gpanders/vim-oldfiles'
```
