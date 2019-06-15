let g:tnite#actions = {
\   "edit": function('tnite#actions#edit'),
\   "tabedit": function('tnite#actions#tabedit'),
\   "jump": function('tnite#actions#jump'),
\   "switch": { fname, option -> tnite#actions#switch(fname, option, g:tnite#actions.edit) },
\   "tabswitch": { fname, option -> tnite#actions#switch(fname, option, g:tnite#actions.tabedit) },
\ }

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
