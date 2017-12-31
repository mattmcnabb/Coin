Describe "ConvertTo-Symbol" {
    InModuleScope "Coin" {
        It "converts to upper-case" {
            ConvertTo-Symbol -Symbols "abc" | Should BeExactly "ABC"
        }

        It "joins strings" {
            ConvertTo-Symbol -Symbols "ABC", "DEF" | Should Be "ABC,DEF"
        }
    }
}
