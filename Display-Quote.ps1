function Show-Quote {
    param (
        $quotesPath,
        [string]$QuoteSeparator = '᚛'
    )
    if (Test-Path $quotesPath) {
        $quotes = Get-Content $quotesPath | Where-Object { $_.Trim() -ne "" }
        $quote = Get-Random -InputObject $quotes

        function Format-Text {
            param (
                [string]$Text,
                [int]$Width = 60,
                [string]$Separator = $QuoteSeparator  # Pass the separator down
            )

            # Extract just the quote part (before the author)
            $quoteOnly = $Text
            $separatorIndex = $Text.IndexOf($Separator)

            # If separator exists, split the quote and author
            if ($separatorIndex -gt 0) {
                $quoteOnly = $Text.Substring(0, $separatorIndex).Trim()
            }
            # Otherwise, treat the whole text as the quote

            $wrapped = ''
            $words = $quoteOnly -split ' '
            $line = ''

            foreach ($word in $words) {
                # Check if adding the next word would exceed the width
                if (($line.Length + $word.Length + 1) -gt $Width) {
                    $wrapped += "$line`n"
                    $line = $word
                }
                else {
                    if ($line -ne '') { $line += ' ' }
                    $line += $word
                }
            }

            $wrapped += "$line"
            # Pass the full text to Enclose-Text for author/position extraction
            $wrapped = Add-Border -Text $wrapped -FullQuote $Text
            return $wrapped
        }

        function Add-Border {
            param (
                [string]$Text,
                [string]$FullQuote,
                [string]$Separator = $QuoteSeparator  # Pass the separator down
            )

            $lines = $Text -split "`n"
            $maxLen = ($lines | Measure-Object -Property Length -Maximum).Maximum
            $result = @()
            $chars = '━' * ($maxLen)
            $result += "┏$chars┓"

            foreach ($line in $lines) {
                $padding = ' ' * ($maxLen - $line.Length)
                $result += "┃$line$padding┃░"
            }

            $result += "┗$chars┛░"
            # Use the full quote for extracting author
            $author = Get-Author -Text $FullQuote -Separator $Separator

            if ($author) {
                $chars = '░' * ($maxLen - $author.Length + 1)
                $result += " ░$author$chars"
            }

            return $result -join "`n"
        }

        function Get-Author {
            param (
                [string]$Text,
                [string]$Separator = $QuoteSeparator  # Pass the separator down
            )

            # Find the position of the separator character
            $separatorIndex = $Text.IndexOf($Separator)

            if ($separatorIndex -eq -1 || $separatorIndex -ge $Text.Length - 1) {
                return $null  # No author found or separator at the end
            }

            # Extract everything after the separator and trim whitespace
            $author = $Text.Substring($separatorIndex + 1).Trim()

            # Clean up any newlines or extra whitespace
            return ($author -replace '\s+', ' ')
        }

        # And modify how you call it:
        $wrappedLines = Format-Text -Text $quote -Width 40 -Separator $QuoteSeparator
        Write-Host $wrappedLines
    }
}