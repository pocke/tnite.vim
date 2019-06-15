function! tnite#start(cmds, action, option) abort
  let buf_num = 0
  let buf_num = term_start(a:cmds, {"exit_cb": { -> s:callback(buf_num, a:action, a:option) }})
  if buf_num == 0
    echom 'failed to open terminal'
    return
  endif
endfunction

function! s:callback(bufn, action_key, option) abort
  " Sleep is necessary to wait render output of command
  sleep 100m
  let winn = bufwinnr(a:bufn)
  let Action = g:tnite#actions[a:action_key]

  let lines = getbufline(a:bufn, 1)
  execute winn . 'close'
  for line in lines
    if trim(line) == ""
      continue
    endif
    call Action(line, a:option)
  endfor
endfunction

function! tnite#read_from_prompt(prompt) abort
  call inputsave()
  let r = input(a:prompt)
  call inputrestore()
  return r
endfunction

function! s:switch(fname, option, fallback) abort
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

function! s:edit(fname, option) abort
  let target = s:split_fname_and_lnum(a:fname, a:option)

  execute 'edit' target.fname
  call s:jump(target)
endfunction

function! s:tabedit(fname, option) abort
  let target = s:split_fname_and_lnum(a:fname, a:option)

  execute 'tabedit' target.fname
  call s:jump(target)
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

let g:tnite#actions = {
\   "edit": function('s:edit'),
\   "tabedit": function('s:tabedit'),
\   "switch": { fname, option -> s:switch(fname, option, g:tnite#actions.edit) },
\   "tabswitch": { fname, option -> s:switch(fname, option, g:tnite#actions.tabedit) },
\ }
