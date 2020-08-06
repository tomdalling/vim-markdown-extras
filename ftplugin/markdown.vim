if !exists('g:markdown_extras_enable_mappings')
  let g:markdown_extras_enable_mappings = 1
endif

" default mappings
if g:markdown_extras_enable_mappings

  if !hasmapto('<Plug>markdown_extras-link-edit', 'n')
    nmap <buffer> <c-]> <Plug>(markdown_extras-link-edit)
    nmap <buffer> gf <Plug>(markdown_extras-link-edit)
  endif

  if !hasmapto('<Plug>markdown_extras-link-vsplit', 'n')
    nmap <buffer> gF <Plug>(markdown_extras-link-vsplit)
  endif

  if !hasmapto('<Plug>markdown_extras-para-wrap', 'n')
    nmap <buffer> <cr> <Plug>(markdown_extras-para-wrap)
  endif

endif
