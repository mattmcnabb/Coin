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
        $Coins | Select-Object -Property @{n="SortOrder"; e={[int]$_.SortOrder}},* -ExcludeProperty SortOrder
    }
    else
    {
        $Coins | Where-Object Id -in $Watched | Select-Object -Property @{n = "SortOrder"; e = {[int]$_.SortOrder}},* -ExcludeProperty SortOrder
    }
}
