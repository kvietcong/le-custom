" ============================
" == VSCode NeoVim settings ==
" ============================

nnoremap <silent> <C-j> :call VSCodeNotify("workbench.action.navigateDown")<CR>
nnoremap <silent> <C-k> :call VSCodeNotify("workbench.action.navigateUp")<CR>
nnoremap <silent> <C-h> :call VSCodeNotify("workbench.action.navigateLeft")<CR>
nnoremap <silent> <C-l> :call VSCodeNotify("workbench.action.navigateRight")<CR>

nnoremap gr <Cmd>call VSCodeNotify("editor.action.goToReferences")<CR>
