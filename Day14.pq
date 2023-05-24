/* Problem Challenge

Instructions:
Select [CustomerKey], [EmailAddress], [EnglishOccupation] and [YearlyIncome] for the
customers whose [BirthDate] was not on a weekend (Saturday, Sunday).*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    Dim_Customer = Source{[Schema = "dbo", Item = "DimCustomer"]}[Data],
    //#"Filtered Rows" = Table.SelectRows(Dim_Customer, each [BirthDate] = Date.DayOfWeek([BirthDate])),
    #"Filtered Rows" = Table.SelectRows(Dim_Customer, each not List.Contains({1, 7}, Date.DayOfWeek([BirthDate]))),
    #"Select Column" = Table.SelectColumns(#"Filtered Rows", {"CustomerKey", "EmailAddress", "EnglishOccupation", "YearlyIncome"})
in
    #"Select Column"