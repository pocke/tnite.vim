function! tnite#actions#switch(fname, option, fallback) abort
  let target = s:split_fname_and_lnum(a:fname, a:option)

  let bufnr = bufnr(target.fname)
  let winids = win_findbuf(bufnr)

  if len(winids) != 0
    call win_gotoid(winids[0])
    call s:jump(target)
  else
    call a:fallback(a:fname, a:option)
  endif
endfunction

function! tnite#actions#edit(fname, option) abort
  let target = s:split_fname_and_lnum(a:fname, a:option)

  execute 'edit' target.fname
  call s:jump(target)
endfunction

function! tnite#actions#tabedit(fname, option) abort
  let target = s:split_fname_and_lnum(a:fname, a:option)

  execute 'tabedit' target.fname
  call s:jump(target)
endfunction

function! tnite#actions#jump(lnum, option) abort
  execute a:lnum
endfunction

function! s:split_fname_and_lnum(fname, option) abort
  let ret = {}
  if get(a:option, 'jump_to_line')
    let ret.fname = matchstr(a:fname, '\v^.+\ze:[0-9]+$')
    let ret.lnum = str2nr(matchstr(a:fname, '\v[0-9]+$'))
  else
    let ret.fname = a:fname
    let ret.lnum = 0
  endif
  return ret
endfunction

function! s:jump(target) abort
  if a:target.lnum
    execute a:target.lnum
  endif
endfunction
