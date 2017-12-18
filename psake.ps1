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

task Test -Depends GenerateHelp -action {
    Invoke-Pester -Script $PSScriptRoot -EnableExit:$TestExit -PesterOption @{IncludeVSCodeMarker = $true}
} -description "runs Pester tests"

task Clean -depends Test -action {
    Remove-Item -Path $BuildTempPath -Confirm:$false -Recurse
} -description "cleans up the build directory"

task Build -depends Test

task PreDeploy -action {
    if (!$env:APPVEYOR_REPO_TAG)
    {
        exit 0
    }
} -description "checks to see if the build was pushed by a tag"

Task Deploy {
    Import-Module PowerShellGet -Force
    Publish-Module -Path $BuildModulePath -NuGetApiKey ($env:PSGallery_Api_Key) -Confirm:$false -Verbose
} -description "deploys the built module to the Powershell Gallery"
