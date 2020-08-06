# vim-markdown-extras

Extra functionality for markdown files.

Disable all default mappings with:

```vim
let g:markdown_extras_enable_mappings = 0
```

## `<Plug>(markdown_extras-link-edit)`

Takes the URL of the markdown link under the cursor and `:edit`s it, as if it
were a path.

Default normal-mode mappings:

 - `<c-]>` (jump to definition)
 - `gf` (go file)

## `<Plug>(markdown_extras-link-vsplit)`

Takes the URL of the markdown link under the cursor and `:vsplit`s it, as if it
were a path.

Default normal-mode mappings:

 - `gF` (go file, with GUSTO)

## `<Plug>(markdown_extras-para-wrap)`

Hard-wraps the paragraph under the cursor.

Default normal-mode mappings:

 - `<cr>`


## Testing (ignore this)

[inline link](ftplugin/markdown.vim)

[multiline
inline
link](autoload/markdown_extras/link.vim)
