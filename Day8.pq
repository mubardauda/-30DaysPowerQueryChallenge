/* Problem Challenge

Instructions:
Select [Sale Key], [Customer Key], [Invoice Date Key], [Total Excluding Tax], [Tax Amount] and [Profit]
where the [Invoice Date Key] is equal to the last date of each month..
*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Fact_Sale = Source{[Schema="Fact",Item="Sale"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(Fact_Sale,{"Sale Key", "Customer Key", "Invoice Date Key", "Total Excluding Tax", "Tax Amount", "Profit"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each [Invoice Date Key] = Date.EndOfMonth([Invoice Date Key]))
in
    #"Filtered Rows"
