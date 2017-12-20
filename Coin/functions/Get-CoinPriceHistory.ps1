function Get-CoinPriceHistory
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FromSymbol,

        [Parameter(Mandatory)]
        [string]
        $ToSymbol,

        [Parameter()]
        [ValidateSet("Day", "Hour", "Minute")]
        [string]
        $DataInterval = "Hour",

        [int]
        $Aggregate = 1,

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
                tsym = $ToSymbol -join ','
                fsym = $FromSymbol
                toTs = ConvertTo-UnixTime -TimeStamp $Until
                aggregate = $Aggregate
            }
        }
    
        # how to validate that the timespan selected fits within the acceptable range for each endpoint?
        switch ($DataInterval)
        {
            Day
            {
                $Splat["Endpoint"] = "histoday"
                $Splat["Body"]["limit"] = [int]$Timespan.TotalDays
                # the histoday endpoint's aggregate parameter has a max value of 30
                $Splat["Body"]["aggregate"] = [System.Math]::Min(30, $Aggregate)
            }
    
            Hour
            {
                $Splat["Endpoint"] = "histohour"
                $Splat["Body"]["limit"] = [int]$Timespan.TotalHours
            }
    
            Minute
            {
                $Splat["Endpoint"] = "histominute"
                $Splat["Body"]["limit"] = [int]$Timespan.TotalMinutes
            }
        }

        Invoke-CoinRestMethod @Splat |
            Select-Object -ExpandProperty Data |
            Select-Object -Property @{n="Time"; e={ConvertFrom-UnixTime $_.Time}},* -ExcludeProperty Time
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
