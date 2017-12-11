function Get-CoinPriceHistory
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FromSymbol,

        [Parameter(Mandatory)]
        [string[]]
        $ToSymbols,

        [Parameter(Mandatory)]
        [DateTime]
        $TimeStamp
    )
    
    $ts = ConvertTo-UnixTime -TimeStamp $TimeStamp
    
    $Body = @{
        tsyms = $ToSymbols -join ','
        fsym  = $FromSymbol
        ts = $ts
    }

    Invoke-CoinRestMethod -Api "min-api" -Endpoint "pricehistorical" -Body $Body | Select-Object -ExpandProperty $FromSymbol
}
