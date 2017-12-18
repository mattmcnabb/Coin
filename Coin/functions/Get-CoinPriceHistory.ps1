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

        [Parameter()]
        [ValidateSet("Day", "Hour", "Minute")]
        [string]
        $DataInterval = "Hour",

        [Parameter()]
        [DateTime]
        $Since = (Get-Date).AddDays(-1),

        [Parameter()]
        [DateTime]
        $Until = (Get-Date)
    )
    
    try
    {
        $Timespan = $Until - $Since
        Test-Timespan -Timespan $Timespan

        $Splat = @{
            Api = "min-api"
            Body = @{
                tsym = $ToSymbols -join ','
                fsym = $FromSymbol
                toTs = ConvertTo-UnixTime -TimeStamp $Until
            }
        }
    
        # how to validate that the timespan selected fits within the acceptable range for each endpoint?
        switch ($DataInterval)
        {
            Day
            {
                $Splat["Endpoint"] = "histoday"
                $Splat["Body"]["limit"] = $Timespan.TotalDays
            }
    
            Hour
            {
                $Splat["Endpoint"] = "histohour"
                $Splat["Body"]["limit"] = $Timespan.TotalHours
            }
    
            Minute
            {
                $Splat["Endpoint"] = "histominute"
                $Splat["Body"]["limit"] = $Timespan.TotalMinutes
            }
        }
    
        Invoke-CoinRestMethod @Splat | Select-Object -ExpandProperty Data
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}