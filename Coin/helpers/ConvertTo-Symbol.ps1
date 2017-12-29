function ConvertTo-Symbol
{
    [CmdletBinding()]
    param
    (
        [string[]]
        $Symbols
    )

    $Symbols.ToUpper() -join ','
}
