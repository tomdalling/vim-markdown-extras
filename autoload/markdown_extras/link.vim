function! markdown_extras#link#run_with_url(cmd) abort
  let l:url = s:url_of_link_under_cursor()
  if l:url ==# ''
    echoerr 'markdown_extras: failed to determine path of link'
  else
    exe a:cmd fnameescape(l:url)
  endif
endfunction

function! markdown_extras#link#complete(...) abort
  let l:extra_fzf_options = a:0 > 0 ? a:1 : {}
  return s:completion_expr(l:extra_fzf_options)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PRIVATE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO: only handles [inline](links.md) not [reference links][]
" returns empty string on failure
function! s:url_of_link_under_cursor() abort
  if !get(g:, 'loaded_matchup')
    echoerr 'markdown_extras: matchup.vim must be installed for markdown url detection to work'
  endif

  let l:initial_pos = getpos(".")
  let l:url = ''

  " jump to closest opening bracket
  call matchup#motion#find_unmatched(0, 0)

  let l:char = s:get_char_under_cursor()
  if l:char ==# '['
    " move one character after the closing ]
    normal! %l
    if s:get_char_under_cursor() ==# '('
      let l:url = s:get_text_in_parens()
    endif
  elseif l:char ==# '('
    let l:url = s:get_text_in_parens()
  endif

  call setpos('.', l:initial_pos)

  return l:url
endfunction

function! s:get_char_under_cursor(...) abort
  let l:col = col('.') + (a:0 == 0 ? 0 : a:1)
  let l:col = max([1, l:col])
  " why is this so insane, vim?
  return matchstr(getline('.'), '\%' . l:col . 'c.')
endfunction

function! s:get_text_in_parens() abort
  let l:initial_yank = @"

  normal! yib
  let l:text = @"

  let @" = l:initial_yank
  return l:text
endfunction

function! s:completion_expr(extra_fzf_options) abort
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
    \ 'reducer': { lines -> s:build_link(l:LineParser(lines[0])) },
    \ 'options': ['--delimiter=\\t'],
    \ 'placeholder': '{1}',
  \}

  let l:full_fzf_options = extend(l:default_fzf_options, a:extra_fzf_options)
  if has_key(l:full_fzf_options, 'line_parser')
    unlet l:full_fzf_options.line_parser
  endif

  return fzf#vim#complete(fzf#vim#with_preview(l:full_fzf_options))
endfunction

function! s:build_link(link)
  " -1 because we want the character before the insert-mode cursor
  let l:prev_char = s:get_char_under_cursor(-1)
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

