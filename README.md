tnite.vim
===

Apply action to output of `:terminal`.
It's simple.


Example
---


Find file from git with peco, and open it in a new tab.


```vim
nnoremap <silent><Space>f :<C-u>call tnite#start(["sh", "-c", "git ls-files \| peco --initial-filter Fuzzy"], "tabedit", {})<CR>
```

### Options

#### `jump_to_line`

Default: false

Jump to specified line number. Format is `file_name:lineno`.
Example: `autoload/tnite.vim:42`
