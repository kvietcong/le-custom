Set-Alias -Name vim -Value nvim
# Set-Alias -Name cd -Value z -Option AllScope
Set-PoshPrompt -Theme ~/.mytheme.omp.json

function DirCS { cd 'D:\Documents\Computer Science\' }
function DirDots { cd 'D:\Documents\le-custom\' }
function DirNotes { cd 'D:\Documents\Notes\' }
function DirUW { cd 'D:\Documents\UW\' }
function DirAppData { cd '~\AppData\' }

function Notes { cd 'D:\Documents\Notes\' && nvim Index.md}
function ConfigNvim { dirdots && cd 'dotfiles\.config\nvim' && nvim }

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell) -join "`n"
})
