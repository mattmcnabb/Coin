function Test-Timespan
{
    [CmdletBinding()]
    param
    (
        [Timespan]
        $Timespan
    )

    if ($Timespan.Ticks -lt 0)
    {
        $Splat = @{
            ExceptionType = "InvalidOperationException"
            Message = "You specified a negative timespan! Make sure the beginning comes before the end."
            ErrorCategory = "InvalidArgument"
        }

        $ErrorRecord = New-ErrorRecord @Splat
        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    }
}
