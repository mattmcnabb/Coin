function Get-CoinPrice
{
    [CmdletBinding()]
    param
    (
        [string[]]
        $FromSymbols,

        [string[]]
        $ToSymbols
    )

    $Body = @{
        tsyms = ConvertTo-Symbol -Symbols $ToSymbols
        fsyms = ConvertTo-Symbol -Symbols $FromSymbols
    }

    $Raw = Invoke-CoinRestMethod -Api "min-api" -Endpoint "pricemultifull" -Body $Body | Select-Object -ExpandProperty Raw

    foreach ($FromSymbol in $FromSymbols)
    {
        foreach ($ToSymbol in $ToSymbols)
        {
            $Raw.$FromSymbol.$ToSymbol
        }
    }
}
