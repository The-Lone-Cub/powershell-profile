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
            # Ensure $maxLen accounts for potential empty lines if $Text is empty
            $maxLen = if ($lines.Length -gt 0) { ($lines | Measure-Object -Property Length -Maximum).Maximum } else { 0 }
            $result = @()
            # Top border: Length = $maxLen + 2
            $topBorderChars = '━' * ($maxLen)
            $result += "┏$topBorderChars┓"

            # Text lines: Length = 1 + text + padding + 1 + 1 = $maxLen + 3
            for ($i = 0; $i -lt $lines.Length; $i++) {
                $paddingCount = $maxLen - $lines[$i].Length
                # Ensure padding is not negative if a line somehow exceeds maxLen
                if ($paddingCount -lt 0) { $paddingCount = 0 }
                $padding = ' ' * $paddingCount
                # Keep the trailing ║ as requested
                if($i -eq 0) {
                    $result += "┃$($lines[$i])$padding┃═══╗"
                } else {
                    $result += "┃$($lines[$i])$padding┃▒▒▒║"
                }
            }

            # Bottom border (initial): Should match text line length ($maxLen + 3)
            $bottomBorderChars = '━' * ($maxLen)
            $initialBottomBorder = "┗$bottomBorderChars┛▒▒▒║" # Add the trailing ║
            $result += $initialBottomBorder # Add the quote's bottom border

            # Author handling: Add the author line *after* the bottom border if author exists
            $author = Get-Author -Text $FullQuote -Separator $Separator
            if ($author) {
                # Calculate filler for author line to match total length ($maxLen + 3)
                # Fixed parts: ' ╚═' (3 chars), Author (variable), '╝' (1 char) = $author.Length + 4 chars
                $fillerCount = ($maxLen + 4) - ($author.Length + 4)
                # Ensure filler is not negative
                if ($fillerCount -lt 0) { $fillerCount = 0 }
                $fillerChars = '▒' * $fillerCount

                $shadow = '═' * ($maxLen)
                $result += "   ║▒$author$fillerChars║"
                $result += "   ╚═$shadow╝"
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

#██████╗
#"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝