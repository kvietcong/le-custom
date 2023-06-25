Set-Alias -Name vim -Value nvim
Set-Alias -Name cd -Value z -Option AllScope
$env:NEOVIDE_MULTIGRID="true"
function quit { exit }
Set-PoshPrompt -Theme ~/.mytheme.omp.json

# Vi Mode
$PSReadLineOptions = @{
    EditMode = "vi"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true`
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

# Zoxide Setup
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})

# Fancy Prompt
Invoke-Expression (&starship init powershell)

# Tab Completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Chord Ctrl+n -Function MenuComplete
Set-PSReadlineKeyHandler -Chord Ctrl+n -Function TabCompleteNext
Set-PSReadlineKeyHandler -Chord Ctrl+p -Function TabCompletePrevious

# Autocomplete for fd and rg
Import-Module $HOME\Documents\PowerShell\_fd.ps1
Import-Module $HOME\Documents\PowerShell\_rg.ps1

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

$env:FZF_DEFAULT_COMMAND='fd -H -L -E .git -t f'
$env:FZF_CTRL_T_COMMAND=$env:FZF_DEFAULT_COMMAND
$env:FZF_CTRL_T_OPTS='--preview "bat --color=always --line-range=:500 {}"'

Clear-Host # Make sure everything is cleared
