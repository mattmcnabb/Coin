[CmdletBinding()]
param
(
    [string[]]
    $Task
)

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo -Verbose:($VerbosePreference -eq 'Continue')
exit ([int](-not $psake.build_success ))
