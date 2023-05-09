/* Problem Challenge:
Instructions:
Select [Stock Item Key], [Stock Item] and [Color] where the [Stock Item Key] is an even number and the [Color] is not N/A
*/

// MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    #"Dimension_Stock Item" = Source{[Schema="Dimension",Item="Stock Item"]}[Data],
    #"Select Column" = Table.SelectColumns(#"Dimension_Stock Item", {"Stock Item Key", "Stock Item", "Color"}),
    #"Filtered Rows" = Table.SelectRows(#"Select Column", each [Color] <> "N/A" and Number.IsEven([Stock Item Key]))
in
    #"Filtered Rows"


// SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%2006.pq
 let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    #"Dimension_Stock Item" = Source{[Schema="Dimension",Item="Stock Item"]}[Data],
    #"Filtered Rows" = Table.SelectRows ( #"Dimension_Stock Item" , each [Color] <> "N/A" and Number.Mod([Stock Item Key], 2) < 1),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Stock Item Key", "Stock Item", "Color"})
in
    #"Removed Other Columns"
