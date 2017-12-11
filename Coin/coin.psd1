@{
    NestedModules      = @('coin.psm1')
    ModuleVersion      = '0.1.0'
    GUID               = '06d29747-e4a1-4115-a176-edda1e66a331'
    Author             = 'Matt McNabb'
    Copyright          = '(c) 2017 Matt McNabb. All rights reserved.'
    Description        = 'A PowerShell module for retrieving data about cryptocurrencies using the CryptoCompare API'
    PowerShellVersion  = '5.1'
    FunctionsToExport  = @(
        "Get-Coin"
        "Get-CoinPrice"
        "Get-CoinPriceHistory"
    )
    PrivateData        = @{
        PSData = @{
            Tags = @("Crypto", "CryptoCurrency", "Currency", "Bitcoin","CryptoCompare","Ethereum","Ether","Litecoin")
            LicenseUri = "https://github.com/mattmcnabb/Coin/blob/master/LICENSE"
            ProjectUri = "https://github.com/mattmcnabb/Coin"
            ReleaseNotes = 'Very early draft version - supports listing coins, getting price by coin, and daily price history'
        }
    }
}
