
InModuleScope "Coin" {
    Describe "ConvertTo-Symbol" {
        It "converts to upper-case" {
            ConvertTo-Symbol -Symbols "abc" | Should BeExactly "ABC"
        }

        It "joins strings" {
            ConvertTo-Symbol -Symbols "ABC", "DEF" | Should Be "ABC,DEF"
        }
    }
}
