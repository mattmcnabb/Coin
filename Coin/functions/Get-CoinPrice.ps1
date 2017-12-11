function Get-CoinPrice
{
    [CmdletBinding()]
    param
    (
        [string]
        $FromSymbol,

        [string[]]
        $ToSymbols
    )

    $Body = @{
        tsyms = $ToSymbols -join ','
        fsym  = $FromSymbol
    }

    Invoke-CoinRestMethod -Api "min-api" -Endpoint "price" -Body $Body
}
