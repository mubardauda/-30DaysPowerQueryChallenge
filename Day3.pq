/* Problem Challenge:

Instructions:
Select the [ProductKey], [EnglishProductName] and an aggregated [TotalRevenue] column which is the
sum of a new computed column [TotalUnitPrice] made up of [OrderQuantity] multiplied by [UnitPrice] where the [TotalRevenue] is above one million.*/
//NOTE: There is a merged column of DimProduct and FactResellerSales in the FactResellerColumn Table. So I expand it, instead of creating a new merge to achieve the solution.

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_FactResellerSales = Source{[Schema = "dbo", Item = "FactResellerSales"]}[Data],
    #"Expanded DimProduct" = Table.ExpandRecordColumn(
        dbo_FactResellerSales, "DimProduct", {"EnglishProductName"}, {"EnglishProductName"}
    ),
    #"Removed Other Columns" = Table.SelectColumns(
        #"Expanded DimProduct", {"ProductKey", "EnglishProductName", "OrderQuantity", "UnitPrice"}
    ),
    #"Inserted Multiplication" = Table.AddColumn(
        #"Removed Other Columns", "TotalUnitPrice", each [OrderQuantity] * [UnitPrice], Currency.Type
    ),
    #"Grouped Rows" = Table.Group(
        #"Inserted Multiplication",
        {"ProductKey", "EnglishProductName"},
        {{"TotalRevenue", each List.Sum([TotalUnitPrice]), type number}}
    ),
    #"Filtered Rows" = Table.SelectRows(#"Grouped Rows", each [TotalRevenue] > 1000000)
in
    #"Filtered Rows"

