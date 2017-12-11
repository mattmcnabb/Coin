function ConvertFrom-UnixTime
{
    [CmdletBinding()]
    [OutputType([DateTime])]
    param
    (
        [Parameter(Mandatory)]
        [int]
        $TimeStamp
    )
    
    $Origin = [DateTime]"1/1/1970"
    $Origin.AddSeconds($TimeStamp)
}
