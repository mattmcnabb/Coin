function ConvertTo-UnixTime
{
    [CmdletBinding()]
    [OutputType([DateTime])]
    param
    (
        [Parameter(Mandatory)]
        [DateTime]
        $TimeStamp
    )
    
    $Origin = [DateTime]"1/1/1970"
    [Math]::Floor(($TimeStamp - $Origin | Select-Object -ExpandProperty TotalSeconds))
}
