let g:tnite#actions = {
\   "edit": "edit",
\   "tabedit": "tabedit",
\ }

function! tnite#start(cmds, action) abort
  let buf_num = 0
  let buf_num = term_start(a:cmds, {"exit_cb": { -> s:callback(buf_num, a:action) }})
  if buf_num == 0
    echom 'failed to open terminal'
    return
  endif
  tnoremap <buffer><nowait><Esc> <Esc>
endfunction

function! s:callback(bufn, action_key) abort
  " Sleep is necessary to wait render output of command
  sleep 100m
  let winn = bufwinnr(a:bufn)
  let action = g:tnite#actions[a:action_key]

  let lines = getbufline(a:bufn, 1)
  execute winn . 'close'
  for line in lines
    if trim(line) == ""
      continue
    endif
    execute action line
  endfor
endfunction

function! tnite#read_from_prompt(prompt) abort
  call inputsave()
  let r = input(a:prompt)
  call inputrestore()
  return r
endfunction
