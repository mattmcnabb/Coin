properties {
    if ($env:APPVEYOR)
    {
        $ModuleName = $env:APPVEYOR_PROJECT_NAME
        $Version = $env:APPVEYOR_BUILD_VERSION
        $TestExit = $true 
    }
    else
    {
        $ModuleName = Split-Path $PSScriptRoot -Leaf
        $Version = '0.1.0.0'
        $TestExit = $false
    }

    $ProjectModulePath = Join-Path $PSScriptRoot $ModuleName
    $ProjectHelpersPath = Join-Path $ProjectModulePath "helpers"
    $ProjectFunctionsPath = Join-Path $ProjectModulePath "functions"
    $ProjectDocsPath = Join-Path $PSScriptRoot "docs"
    $BuildTempPath = New-Item -Path $env:TEMP -ItemType Directory -Name "$ModuleName`_$((Get-Date).ToFileTime())"
    $BuildModulePath = New-Item -ItemType Directory -Path $BuildTempPath -Name $ModuleName
    $BuildPsm1Path = Join-Path $BuildModulePath "$ModuleName.psm1"
    $BuildManifestPath = Join-Path $BuildModulePath "$ModuleName.psd1"
    $BuildDocsPath = Join-Path $BuildModulePath "en-US"
}

task Default -depends Build

task Compile -Action {
    Get-ChildItem -Path $ProjectModulePath -Filter "*.ps?1" | Copy-Item -Destination $BuildModulePath -Recurse -Force
    foreach ($Script in (Get-ChildItem -Path $ProjectHelpersPath, $ProjectFunctionsPath))
    {
        Get-Content -Path $Script.FullName | Out-File -FilePath $BuildPsm1Path -Append -Encoding utf8
        
    }
    $ManifestData = Get-Content $BuildManifestPath
    $ManifestData = $ManifestData -replace "ModuleVersion\s+=\s+`"\d+\.\d+\.\d+\.\d+`"", "ModuleVersion = `"$Version`""
    $ManifestData | Out-File $BuildManifestPath -Force -Encoding utf8
} -description "compiles separate function files into a single module"

task GenerateHelp -Depends Compile -Action {
    $null = New-Item -ItemType Directory -Path $BuildDocsPath -Force
    $null = New-ExternalHelp -Path $ProjectDocsPath -OutPutPath $BuildDocsPath -Encoding ([System.Text.Encoding]::UTF8) -Force    
} -description "builds external help file from markdown"

task Analyze -depends GenerateHelp -action {
    $AnalyzeSplat = @{
        Path        = $BuildModulePath
        ExcludeRule = "PSUseDeclaredVarsMoreThanAssignments", "PSUseShouldProcessForStateChangingFunctions"
        Severity    = "Warning"
    }
    $Violations = Invoke-ScriptAnalyzer @AnalyzeSplat
    if ($Violations)
    {
        foreach ($Violation in $Violations)
        {
            $ErrorSplat = @{
                Message           = $Violation.Message
                Category          = $Violation.RuleName
                TargetObject      = "{Script:{0}, Line:{1}}" -f $Violation.ScriptName, $Violation.Line
                RecommendedAction = $Violation.SuggestedCorrections
            }
            Write-Error @ErrorSplat -ErrorAction Stop
        }
    }
} -description "runs the PSScriptAnalyzer against the built module"

task TestManifest -depends Analyze -action {
    Test-ModuleManifest -Path $BuildManifestPath -ErrorAction Stop
} -description "tests the validity of the module manifest"

task Test -Depends TestManifest -action {
    Invoke-Pester -Script $PSScriptRoot -EnableExit:$TestExit -PesterOption @{IncludeVSCodeMarker = $true}
} -description "runs Pester tests"

task Clean -depends Test -action {
    Remove-Item -Path $BuildTempPath -Confirm:$false -Recurse
} -description "cleans up the build directory"

task Build -depends Test

Task Deploy {
    if ($env:APPVEYOR_REPO_COMMIT_MESSAGE -match "^!Deploy")
    {
        Import-Module PowerShellGet -Force
        Publish-Module -Path $BuildModulePath -NuGetApiKey ($env:PSGallery_Api_Key) -Confirm:$false -Verbose
    }
    else
    {
        Write-Verbose -Message "The commit message was not marked for deployment - no action was taken"
    }

} -description "deploys the built module to the Powershell Gallery if committed with a message starting with '!Deploy'"
