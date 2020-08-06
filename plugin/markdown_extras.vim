" Vim plugin that adds extra functionality to markdown files
" Maintainer: Tom Dalling
" License: MIT

" compatibility crap
let s:save_cpo = &cpo
set cpo&vim

" prevent double loading
if exists("g:loaded_markdown_extras")
  finish
endif
let g:loaded_markdown_extras = 1

" <Plug> mappings
nnoremap <Plug>(markdown_extras-link-edit)
  \ call markdown_extras#link#run_with_url('edit')
nnoremap <Plug>(markdown_extras-link-vsplit)
  \ call markdown_extras#link#run_with_url('vsplit')
nnoremap <Plug>(markdown_extras-para-wrap) vipgq$

" compatibility crap
let &cpo = s:save_cpo
unlet s:save_cpo