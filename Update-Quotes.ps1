# Ensure the quotes file exists
if (-not (Test-Path "$HOME\quotes.txt")) {
    New-Item -Path "$HOME\quotes.txt" -ItemType File
}

while ((Get-Content "$HOME\quotes.txt").Count -lt 200) {
    $uri = "https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en"
    $response = Invoke-WebRequest -Uri $uri
    $quote = $response.Content | ConvertFrom-Json
    $quote = $quote.quoteText + " ᚛ " + $quote.quoteAuthor

    # Replace Unknown Author with Anonymous
    if ($quote -match "᚛ Unknown Author") {
        $quote = $quote -replace "᚛ Unknown Author", "᚛ Anonymous"
    }

    # Check if quote already exists in quotes.txt
    $quotes = Get-Content "$HOME\quotes.txt"
    if ($quotes -contains $quote) {
        continue  # Skip to the next iteration if quote already exists
    }

    # Append the new quote to quotes.txt
    $quote | Out-File -FilePath "$HOME\quotes.txt" -Append

    # Sleep for 1 second before the next request
    Start-Sleep -Seconds 1
    Write-Host "Added #$((Get-Content "$HOME\quotes.txt").Count): $quote`n"
}