clear # Make sure everything is cleared first

Set-Alias -Name vim -Value nvim
# Set-Alias -Name cd -Value z -Option AllScope
Set-PoshPrompt -Theme ~/.mytheme.omp.json

# Vi Mode
$PSReadLineOptions = @{
    EditMode = "vi"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
}
Set-PSReadLineOption @PSReadLineOptions
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

function DirProjects { cd 'D:\Documents\Projects\' }
function DirDots { cd 'D:\Documents\le-custom\' }
function DirNotes { cd 'D:\Documents\Notes\' }
function DirUW { cd 'D:\Documents\UW\' }
function DirAppData { cd '~\AppData\' }
function quit { exit }

function Notes { cd 'D:\Documents\Notes\' && nvim ".\- Index -.md"}
function ConfigNvim { dirdots && cd 'dotfiles\.config\nvim' && nvim }

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})

Invoke-Expression (&starship init powershell)

$env:NEOVIDE_MULTIGRID="true"
