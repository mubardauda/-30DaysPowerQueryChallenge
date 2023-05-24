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