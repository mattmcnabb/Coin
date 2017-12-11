@{
    NestedModules      = @('coin.psm1')
    ModuleVersion      = '0.1.0'
    # CompatiblePSEditions = @()
    GUID               = '06d29747-e4a1-4115-a176-edda1e66a331'
    Author             = 'Matt McNabb'
    Copyright          = '(c) 2017 Matt McNabb. All rights reserved.'
    Description        = 'A PowerShell module for retrieving data about cryptocurrencies. Leverages the CryptoCompare API and the CryptoCompareAPI .NET library from Joan Caron'
    PowerShellVersion  = '5.1'
    # RequiredModules = @()
    # FormatsToProcess = @()
    FunctionsToExport  = @(
        "Get-Coin"
        "Get-CoinPrice"
        "Get-CoinPriceHistory"
    )
    # AliasesToExport = '*'
    PrivateData        = @{
        PSData = @{
            Tags = @("Crypto", "CryptoCurrency", "Currency", "Bitcoin","CryptoCompare","Ethereum","Ether","Litecoin")
            # LicenseUri = ''
            ProjectUri = "https://github.com/mattmcnabb/Coin"
            # ReleaseNotes = ''
        }
    }
}
