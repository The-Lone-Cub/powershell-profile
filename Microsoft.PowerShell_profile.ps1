oh-my-posh init pwsh --config 'C:\Users\User\Documents\PowerShell\clean-detailed.omp.json' | Invoke-Expression

# Terminal icons
Import-Module Terminal-Icons

# Display a random quote on startup
Import-Module $HOME\Documents\PowerShell\Display-Quote.ps1
$quotesPath = "$HOME\quotes.txt"


# PSReadLine
Import-Module PSReadLine
Import-Module Az.Tools.Predictor
Import-Module -Name CompletionPredictor

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

function Clear-Host {
  [Console]::Clear()
  Show-Quote -quotesPath $quotesPath
}

Import-Module Az.Tools.Predictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
$host.ui.rawui.windowtitle="$([char]0x221E) The Lone Cub"

Clear-Host
Write-Host ""