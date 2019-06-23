
let s:terminals = []
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

  call add(s:terminals, winbufnr(win_getid()))
endfunction

function! Remove(arr, i)
  if a:i == 0
    return a:arr[(a:i + 1):]
  else
    return a:arr[:(a:i - 1)] + a:arr[(a:i + 1):]
endfunction

function! terminal#close()
  let buf = winbufnr(win_getid())
  call terminal#hide()
  let i = index(s:terminals, buf)
  let s:terminals = Remove(s:terminals, i)
  echo s:terminals
  silent execute "normal! :bwipe! " . buf . "\<CR>"
endfunction

function! terminal#hide()
  let winid = win_getid()
  let prevBufnr = s:terminalPrevBufs[winid]
  if bufexists(prevBufnr)
    silent execute "normal! \<C-w>:b " . prevBufnr . "\<CR>"
  else
    while &buftype == 'terminal'
      silent execute "normal! \<C-w>:b#\<CR>"
    endwhile
  endif
endfunction

function! terminal#toggle()
  if &buftype == 'terminal'
    call terminal#hide()
  elseif len(s:terminals) == 0
    call terminal#add()
  else
    call StorePrevBuf()
    silent execute "normal! :b " . s:terminals[0] . "\<CR>"
  endif
endfunction

function! terminal#switch(direction)
  let i = index(s:terminals, winbufnr(win_getid()))
  let length = len(s:terminals)
  let i = a:direction == 'h' ? (i - 1) : (i + 1)
  if i == length
    let i = 0
  elseif i == -1
    let i length - 1
  endif
  silent execute "normal! :b " . s:terminals[i] . "\<CR>"
endfunction

