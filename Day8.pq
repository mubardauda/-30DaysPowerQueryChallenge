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


//SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%2008.pq

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Fact_Sale = Source{[Schema="Fact",Item="Sale"]}[Data],
    #"Filtered Rows" = Table.SelectRows(
        Fact_Sale, 
        each (if Date.Month([Invoice Date Key]) = 2
            then 28
            else if List.Contains({4, 6, 9, 11}, Date.Month([Invoice Date Key])) then 30 else 31)
            - Date.Day([Invoice Date Key]) < 1
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows", {
        "Sale Key", 
        "Customer Key", 
        "Invoice Date Key", 
        "Total Excluding Tax", 
        "Tax Amount", 
        "Profit"
    })
in
    #"Removed Other Columns"