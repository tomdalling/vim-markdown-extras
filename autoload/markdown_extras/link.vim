function! markdown_extras#link#run_with_url(cmd) abort
  let l:url = s:url_of_link_under_cursor()
  if l:url ==# ''
    echoerr 'markdown_extras: Failed to determine path of link'
  else
    exe a:cmd fnameescape(l:url)
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PRIVATE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO: only handles [inline](links.md) not [reference links][]
" returns empty string on failure
function! s:url_of_link_under_cursor() abort
  if !exists('*matchup#init')
    echoerr 'matchup.vim must be installed for markdown url detection to work'
    return ''
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

function! s:get_char_under_cursor() abort
  " why is this so insane, vim?
  return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

function! s:get_text_in_parens() abort
  let l:initial_z = @z

  normal! "zyib
  let l:text = @z

  let @z = l:initial_z
  return l:text
endfunction

