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

## `markdown_extras#link#complete()`

Opens FZF to choose a markdown file to link to, and inserts a link using the
first line (usually the title) of the chosen file.

To define your own mapping, use `<expr>` like this:

```vim
inoremap <expr> <c-x><c-l> markdown_extras#link#complete()
```

Default insert-mode mappings:

 - `<c-x><c-l>` complete link

## Testing (ignore this)

[Inline link](ftplugin/markdown.vim)

[Multiline
inline
link](autoload/markdown_extras/link.vim)

Completion after [

Completion after (

Complete [ inside ( paragraph
