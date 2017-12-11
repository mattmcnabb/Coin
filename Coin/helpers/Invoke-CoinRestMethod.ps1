function Invoke-CoinRestMethod
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateSet("original","min-api")]
        $Api,

        [string]
        $Endpoint,

        [hashtable]
        $Body
    )
    
    $ApiBase = $CoinApis.$Api
    $Splat = @{
        Uri = "{0}/{1}" -f $ApiBase, $Endpoint
    }

    if ($Body)
    {
        $Splat["Body"] = $Body
    }

    Invoke-RestMethod @Splat
}
