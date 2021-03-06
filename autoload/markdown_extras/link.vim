function! markdown_extras#link#run_with_href(cmd) abort
  let l:href = s:href_of_link_under_cursor()
  if l:href ==# ''
    echoerr 'markdown_extras: failed to determine href of link'
  else
    if &autowrite
      update
    endif
    exe a:cmd fnameescape(s:expand_href(l:href))
  endif
endfunction

function! markdown_extras#link#complete(...) abort
  let l:extra_fzf_options = a:0 > 0 ? a:1 : {}
  return s:completion_expr(col('.'), l:extra_fzf_options)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PRIVATE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO: only handles [inline](links.md) not [reference links][]
" returns empty string on failure
function! s:href_of_link_under_cursor() abort
  if !get(g:, 'loaded_matchup')
    echoerr 'markdown_extras: matchup.vim must be installed for markdown href detection to work'
  endif

  let l:initial_pos = getpos(".")
  let l:href = ''

  " jump to closest opening bracket
  call matchup#motion#find_unmatched(0, 0)

  let l:char = s:get_char_under_cursor()
  if l:char ==# '['
    " move one character after the closing ]
    normal! %l
    if s:get_char_under_cursor() ==# '('
      let l:href = s:get_text_in_parens()
    endif
  elseif l:char ==# '('
    let l:href = s:get_text_in_parens()
  endif

  call setpos('.', l:initial_pos)

  return l:href
endfunction

function! s:expand_href(href) abort
  " don't mess with full URLs
  if a:href =~ '^[a-z]\+://'
    return a:href
  end

  if a:href[0] ==# '/'
    " absolute paths without a hostname (e.g. '/abc.md') are interpreted as
    " relative to the current directory
    let l:path = a:href[1:]
  else
    " otherwise, path is interpretted as being relative to the current file
    let l:path = simplify(expand('%:h') . '/' . a:href)
  endif

  " TODO: could check for trailing slash and add 'index.md' or something
  return l:path
endfunction

function! s:get_char_under_cursor() abort
  " why is this so insane, vim?
  return s:get_char_at_col(col('.'))
endfunction

function! s:get_char_at_col(col) abort
  " why is this so insane, vim?
  return matchstr(getline('.'), '\%' . a:col . 'c.')
endfunction

function! s:get_text_in_parens() abort
  let l:initial_yank = @"

  normal! yib
  let l:text = @"

  let @" = l:initial_yank
  return l:text
endfunction

function! s:completion_expr(insert_col, extra_fzf_options) abort
  if !exists('*fzf#complete')
    echoerr 'fzf.vim must be installed for markdown link completion'
    return ''
  endif

  let l:LineParser = get(a:extra_fzf_options, 'line_parser', function('<SID>default_line_parser'))

  " NOTE: the 'placeholder' option is undocumented. It's the "{}" part of the
  " preview command on the FZF command line
  let l:default_fzf_options = {
    \ 'prefix': '',
    \ 'source': 'rg --files -0 | xargs -0 awk ''{print FILENAME "\t" $0}{nextfile}''',
    \ 'reducer': { lines -> s:build_link(a:insert_col, l:LineParser(lines[0])) },
    \ 'options': ['--delimiter=\\t'],
    \ 'placeholder': '{1}',
  \}

  let l:full_fzf_options = extend(l:default_fzf_options, a:extra_fzf_options)
  if has_key(l:full_fzf_options, 'line_parser')
    unlet l:full_fzf_options.line_parser
  endif

  return fzf#vim#complete(fzf#vim#with_preview(l:full_fzf_options))
endfunction

function! s:build_link(insert_col, link)
  let l:prev_char = a:insert_col > 0 ? s:get_char_at_col(a:insert_col-1) : ''
  if l:prev_char ==# '('
    return a:link.path . ')'
  elseif l:prev_char ==# '['
    return a:link.title . '](' . a:link.path . ')'
  elseif l:prev_char ==# ']'
    return '(' . a:link.path . ')'
  else
    return '[' . a:link.title . '](' . a:link.path . ')'
  endif
endfunction

function! s:default_line_parser(line) abort
  let [l:path, l:title] = split(a:line, "\t")
  return {
    \ 'title': trim(trim(l:title, '#')),
    \ 'path': l:path,
    \ }
endfunction

