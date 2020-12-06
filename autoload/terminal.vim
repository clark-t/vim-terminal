let s:terminalPrevBufs = {}

function! IsTerminal()
  return &buftype == 'terminal'
endfunction

function! StorePrevBuf()
  let winid = win_getid()
  if !IsTerminal()
    let s:terminalPrevBufs[winid] = winbufnr(winid)
  endif
endfunction

function! terminal#add()
  call StorePrevBuf()

  if IsTerminal()
    silent execute "normal! \<C-w>:terminal ++curwin\<CR>"
  else
    silent execute "normal! :terminal ++curwin\<CR>"
  endif
endfunction

function! terminal#close()
  if !IsTerminal()
    return
  endif

  let buf = winbufnr(win_getid())
  call terminal#hide()
  silent execute "normal! :bwipe! " . buf . "\<CR>"
endfunction

function! terminal#hide()
  let winid = win_getid()
  let prevBufnr = get(s:terminalPrevBufs, winid, -1)

  if prevBufnr != -1 && bufexists(prevBufnr)
    silent execute "normal! \<C-w>:b " . prevBufnr . "\<CR>"
  else
    while IsTerminal()
      silent execute "normal! \<C-w>:b#\<CR>"
    endwhile
  endif
endfunction

function! terminal#toggle()
  if IsTerminal()
    call terminal#hide()
    return
  endif
  let terminals = term_list()
  if len(terminals) == 0
    call terminal#add()
  else
    call StorePrevBuf()
    silent execute "normal! :b " . terminals[0] . "\<CR>"
  endif
endfunction

function! terminal#switch(direction)
  if !IsTerminal()
    return
  endif

  let terminals = term_list()
  let i = index(terminals, winbufnr(win_getid()))
  let length = len(terminals)
  let i = a:direction == 'h' ? (i - 1) : (i + 1)
  if i == length
    let i = 0
  elseif i == -1
    let i = length - 1
  endif
  silent execute "normal! :b " . terminals[i] . "\<CR>"
endfunction

