﻿$global:l_LoadFullProfile = $false

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

# Define quotesPath at the root level
$quotesPath = "$HOME\Documents\PowerShell\Quotes\quotes.txt"

# Define Clear-Host at the profile root level with lazy loading
function Clear-Host {
  [Console]::Clear()
  
  if (($global:l_LoadFullProfile -eq $true) -and -not (Get-Command Show-Quote -ErrorAction SilentlyContinue)) {
    . $HOME\Documents\PowerShell\Quotes\Display-Quote.ps1
  }

  if($global:l_LoadFullProfile -and (Get-Command Show-Quote -ErrorAction SilentlyContinue)) {
      Show-Quote -quotesPath $quotesPath
  }
}

# Reload PowerShell with other theme and icons when needed
function Reload-PowerShell {
  $global:l_LoadFullProfile = $true
  
  # Import Modules
  Import-Module Az.Tools.Predictor -DisableNameChecking
  Import-Module CompletionPredictor -DisableNameChecking
  Import-Module Terminal-Icons

  # Cache oh-my-posh config path
  $ompName = 'clean-detailed'
  $ompConfig = "C:\Users\User\Documents\PowerShell\Scripts\$ompName.omp.json"
  oh-my-posh init pwsh --config $ompConfig | Invoke-Expression

  # Consolidated admin check
  $isAdmin = ( `
          [Security.Principal.WindowsPrincipal] `
          ([Security.Principal.WindowsIdentity]::GetCurrent()) `
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

  $host.ui.rawui.windowtitle = "$(if ($isAdmin) {'🛡️'} else {'👤'}) The Lone Cub ⫷⫸"

  Clear-Host
}

if ($global:l_LoadFullProfile) {
  . $PROFILE
  Reload-PowerShell
}

if($global:l_LoadFullProfile) {
  Write-Output "" # Synchronise clear behaviour with that of profile loading
}