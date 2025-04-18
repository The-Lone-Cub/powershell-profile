# PSReadLine
Import-Module PSReadLine
Import-Module Az.Tools.Predictor
Import-Module -Name CompletionPredictor

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

# Reload PowerShell with other theme and icons when needed
function Reload-PowerShell {
  oh-my-posh init pwsh --config 'C:\Users\User\Documents\PowerShell\Scripts\clean-detailed.omp.json' | Invoke-Expression

  # Terminal icons
  Import-Module Terminal-Icons

  # Display a random quote on startup
  Import-Module $HOME\Documents\PowerShell\Display-Quote.ps1
  $quotesPath = "$HOME\quotes.txt"

  function Clear-Host {
    [Console]::Clear()
    Show-Quote -quotesPath $quotesPath
  }

  Import-Module Az.Tools.Predictor
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin

  $isAdmin = ([Security.Principal.WindowsPrincipal] `
      [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
      [Security.Principal.WindowsBuiltInRole]::Administrator)

  $symbol = if ($isAdmin) { "🛡️" } else { "👤" }

  $host.ui.rawui.windowtitle = "$symbol The Lone Cub ⫷⫸"


  Clear-Host
  Write-Output ""
}

$l_LoadFullProfile = $false

if ($l_LoadFullProfile) {
  . $PROFILE
  Reload-PowerShell
}