Set-Alias -Name vim -Value nvim
Set-PoshPrompt -Theme ~/.mytheme.omp.json

function DirCS { cd 'D:\Documents\Computer Science\' }
function DirDots { cd 'D:\Documents\le-custom\' }
function DirNotes { cd 'D:\Documents\Notes\' }
function DirUW { cd 'D:\Documents\UW\' }
function DirAppData { cd '~\AppData\' }

function Notes { cd 'D:\Documents\Notes\' && nvim Index.md}
function ConfigNvim { dirdots && cd 'dotfiles\.config\nvim' && nvim lua\\init.lua init.vim }
