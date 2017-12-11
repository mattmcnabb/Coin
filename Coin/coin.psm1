$HelpersPath = Join-Path $PSScriptRoot "helpers"
$FunctionsPath = Join-Path $PSScriptRoot "functions"

foreach ($Script in (Get-ChildItem -Path $HelpersPath,$FunctionsPath))
{
    . $Script.FullName
}

$CoinApis = @{
    "original" = "https://www.cryptocompare.com/api/data"
    "min-api" = "https://min-api.cryptocompare.com/data"
}
