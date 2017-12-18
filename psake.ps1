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
    $ManifestData = $ManifestData -replace "ModuleVersion = `"\d+\.\d+\.\d+\.d+`"", "ModuleVersion = `"$Version`""
    $ManifestData | Out-File $BuildManifestPath -Force -Encoding utf8
}

task GenerateHelp -Depends Compile -Action {
    $null = New-Item -ItemType Directory -Path $BuildDocsPath -Force
    $null = New-ExternalHelp -Path $ProjectDocsPath -OutPutPath $BuildDocsPath -Encoding ([System.Text.Encoding]::UTF8) -Force    
}

task Test -Depends GenerateHelp -action {
    Invoke-Pester -Script $PSScriptRoot -EnableExit:$TestExit -PesterOption @{IncludeVSCodeMarker = $true}
}

task Clean -depends Test -action {
    Remove-Item -Path $BuildTempPath -Confirm:$false -Recurse
}

task Build -depends Clean

Task Deploy {
    if (APPVEYOR_REPO_TAG)
    {
        Import-Module PowerShellGet -Force
        Publish-Module -Path $BuildModulePath -NuGetApiKey ($env:PSGallery_Api_Key) -Confirm:$false -Verbose
    }
}
