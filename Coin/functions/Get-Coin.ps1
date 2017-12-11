function Get-Coin
{
    [CmdletBinding()]
    param
    (
        [switch]
        $All
    )
    
    $ListObject = Invoke-CoinRestMethod -Api "min-api" -Endpoint "all/coinlist"
    $Coins = $ListObject.Data.PSObject.Properties | Select-Object -ExpandProperty Value
    $Watched = $ListObject.DefaultWatchList.CoinIs -split ','

    if ($PSBoundParameters.ContainsKey("All"))
    {
        $Coins
    }
    else
    {
        $Coins | Where-Object Id -in $Watched
    }
}
