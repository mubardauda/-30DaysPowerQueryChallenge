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


//SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%2003.pq

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    // DimReseller
    dbo_DimProduct = Source{[Schema="dbo",Item="DimProduct"]}[Data],
    #"DimProductColumns" = Table.SelectColumns(dbo_DimProduct, {"ProductKey", "EnglishProductName"}),
    // FactResellerSales
    dbo_FactResellerSales = Source{[Schema="dbo",Item= "FactResellerSales"]}[Data][[ProductKey],[OrderQuantity],[UnitPrice]],
    #"Inserted Multiplication" = Table.AddColumn(
        dbo_FactResellerSales, 
        "TotalUnitPrice", 
        each [OrderQuantity] * [UnitPrice], 
        Currency.Type
    ),
    #"Grouped Rows" = Table.Group(#"Inserted Multiplication", {"ProductKey"}, {
        {"TotalRevenue", each List.Sum([TotalUnitPrice]), type number}
    }),
    #"Greater than 1 Million" = Table.SelectRows(
        #"Grouped Rows", 
        each [TotalRevenue] > 1000000
    ),
    #"DimProduct -> Greater Than 1 Million" = Table.Join(
        DimProductColumns, 
        "ProductKey", 
        #"Greater than 1 Million", 
        "ProductKey", 
        JoinKind.Inner
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"DimProduct -> Greater Than 1 Million", {
        "ProductKey", 
        "EnglishProductName", 
        "TotalRevenue"
    })
in
    #"Removed Other Columns"