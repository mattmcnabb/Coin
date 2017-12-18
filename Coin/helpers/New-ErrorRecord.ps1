function New-ErrorRecord
{
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param
    (
        [string]
        $ExceptionType,
        [string]
        $Message,
        $ErrorId,
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory,
        $TargetObject
    )

    $Exception = New-Object -TypeName "System.$ExceptionType" -ArgumentList $Message
    [System.Management.Automation.ErrorRecord]::new(
        $Exception,
        $ErrorId,
        $ErrorCategory,
        $TargetObject
    )
}
