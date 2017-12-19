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
        tsyms = $ToSymbols -join ','
        fsyms  = $FromSymbols -join ','
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
