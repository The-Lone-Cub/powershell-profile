$uri = "https://geek-quote-api.vercel.app/v1/quote"
$response = Invoke-WebRequest -Uri $uri

$quote = $response.Content | ConvertFrom-Json

$quote = $quote.quote + " ᚛ " + $quote.author

# Check whether quote already exists in quotes.txt
if (Test-Path "$HOME\quotes.txt") {
    $quotes = Get-Content "$HOME\quotes.txt"
    if ($quotes -contains $quote) {
        exit
    }
}

# Append the quote to the quotes.txt file
$quote | Out-File -FilePath "$HOME\quotes.txt" -Append