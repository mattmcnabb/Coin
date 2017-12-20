[![Build status](https://ci.appveyor.com/api/projects/status/pkh96uwm37wy6shw?svg=true)](https://ci.appveyor.com/project/mattmcnabb/coin)

# Coin

Coin is a PowerShell module for retrieving information about cryptocurrencies. It leverages the [CryptoCompare API](https://www.cryptocompare.com/api) to achieve this.

## Installation

To install the Coin module from the PowerShell Gallery, just run `Install-Module Coin`.

## Getting Started
Coin can retrieve current or historical data about cryptocurrencies, and can return values in many different currencies. Try these commands for starters:

```powershell
# list the top ten coins
Get-Coin

# list all available coins
Get-Coin -All

# get the current value for Bitcoin in US dollars
Get-CoinPrice -FromSymbol BTC -ToSymbol USD

# get the historical prices for Ether over the last 30 days
$Date = Get-Date
Get-CoinPriceHistory -FromSymbol ETH -ToSymbol USD -DataInterval Day -Since $Date.AddDays(-30) -Until $Date

# get the historical prices for Ether over the last year, in intervals of 10 days
$Date = Get-Date
Get-CoinPriceHistory -FromSymbol ETH -ToSymbol USD -DataInterval Day -Since $Date.AddYears(-1) -Until $Date -Aggregate 10
```
