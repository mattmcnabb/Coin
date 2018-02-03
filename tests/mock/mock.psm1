<#
Mock module
contains test data, mock objects, and functions to support testing
#>

function Get-CanonicalPath
{
    <#
    .SYNOPSIS
    Returns the canonical path of a file or folder
    
    .DESCRIPTION
    Returns the canonical path of a file or folder. The .Net Framework's methods for returning file and folder names don't return the canonical casing of paths, and depend on user input. Get-CanonicalPath ensures that the paths returned match the casing as stored in the file system. This is important for cross compatibility with Unix-like operating systems where the file systems are case-sensitive.
    
    .PARAMETER Path
    A path to return from the file system
    
    .EXAMPLE
    Get-CanonicalPath -Path c:\uSErS\BoB
    
    This example demonstrates returning the actual path stored in the file system instead of the odd casing entered by the user. This example will return:
    C:\users\bob
    
    .NOTES
    From Joel Bennett: another trick to get the canonical path is to wrangle it out of the file system with regex
    (Get-Item ($BuildModulePath -replace '.$', '[$&]')).BaseName
    Or
    (Convert-Path ($BuildModulePath -replace '.$', '[$&]')).BaseName
    since we only need to test against the item basename and not the full path, this could be acceptable
    #>
    
    param
    (
        [string]
        $Path
    )

    if (!([System.IO.File]::Exists($Path) -or [System.IO.Directory]::Exists($Path)))
    {
        return $Path
    }
    
    $Dir = [System.IO.DirectoryInfo]::new($Path)

    if ($Dir.Parent -ne $null)
    {
        Join-Path (Get-CanonicalPath -Path $Dir.Parent.FullName) ($Dir.Parent.GetFileSystemInfos($Dir.Name)[0].Name)
    }
    else
    {
        $Dir.Name.ToUpper()
    }
}
