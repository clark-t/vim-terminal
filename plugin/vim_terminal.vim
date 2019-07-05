
if exists('loaded_vim_terminal')
  finish
endif

let loaded_vim_terminal = 1

nnoremap <silent> <Leader>t :call terminal#toggle()<CR>
tnoremap <silent> <Leader>t <C-w>:call terminal#toggle()<CR>
tnoremap <silent> <Leader><Leader> <C-w>:call terminal#hide()<CR>
tnoremap <silent> <Leader>h <C-w>:call terminal#switch('h')<CR>
tnoremap <silent> <Leader>l <C-w>:call terminal#switch('l')<CR>
tnoremap <silent> <S-Left> <C-w>:call terminal#switch('h')<CR>
tnoremap <silent> <S-Right> <C-w>:call terminal#switch('l')<CR>
tnoremap <silent> <C-d> <C-w>:call terminal#close()<CR>
tnoremap <silent> <Leader>q <C-w>:call terminal#close()<CR>
tnoremap <silent> <Leader>a <C-w>:call terminal#add()<CR>

tnoremap <silent> <Leader>m <C-w>N

