# test that coinpricehistory timespan cannot be negative

Describe "Docs" {
    It "help file exists" {
        $BuildDocsPath = Join-Path $BuildModulePath "en-US"
        $Doc = Join-Path $BuildDocsPath "$ModuleName-help.xml"
        Test-Path $Doc | Should Be $true
    }
}

# test the module manifest - exports the right functions, processes the right formats, and is generally correct
Describe "Manifest" {
    $Content = Get-Content -Path $BuildManifestPath -Raw
    $SB = [scriptblock]::Create($Content)
    $ManifestHash = & $SB

    It "has a valid root module" {
        $ManifestHash.RootModule | Should Be "$ModuleName.psm1"
    }

    It "has a valid Description" {
        $ManifestHash.Description | Should Not BeNullOrEmpty
    }

    It "has a valid guid" {
        $ManifestHash.Guid | Should Be "06d29747-e4a1-4115-a176-edda1e66a331"
    }

    It "has a valid version" {
        $ManifestHash.ModuleVersion | Should Be $Version
    }

    It "has a valid copyright" {
        $ManifestHash.CopyRight | Should Not BeNullOrEmpty
    }
    
    It 'has a valid license Uri' {
        $ManifestHash.PrivateData.Values.LicenseUri | Should Be "https://github.com/mattmcnabb/$ModuleName/blob/master/license"
    }
    
    It 'has a valid project Uri' {
        $ManifestHash.PrivateData.Values.ProjectUri | Should Be "https://github.com/mattmcnabb/$ModuleName"
    }
    
    It "gallery tags don't contain spaces" {
        foreach ($Tag in $ManifestHash.PrivateData.Values.tags)
        {
            $Tag -notmatch '\s' | Should Be $true
        }
    }
}