/* Database: WideWorldImportersDW
Entity: Fact.Order

Instructions:
Select [OrderKey] and [Description] where the modulo of the [Description] length divided by 10 is equal to 1.*/


//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Fact_Order = Source{[Schema="Fact",Item="Order"]}[Data],
    #"Duplicated Column" = Table.DuplicateColumn(Fact_Order, "Description", "Description - Copy"),
    #"Calculated Text Length" = Table.TransformColumns(#"Duplicated Column",{{"Description - Copy", Text.Length, Int64.Type}}),
    #"Calculated Modulo" = Table.TransformColumns(#"Calculated Text Length", {{"Description - Copy", each Number.Mod(_, 10), type number}}),
    #"Filtered Rows" = Table.SelectRows(#"Calculated Modulo", each ([#"Description - Copy"] = 1)),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Order Key", "Description"})
in
    #"Removed Other Columns"


//SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%2004.pq

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Fact_Order = Source{[Schema="Fact",Item="Order"]}[Data],
    #"Filtered Rows" = Table.SelectRows(
        Fact_Order, 
        each Number.Mod(Text.Length([Description]), 10) = 1
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows", {"Order Key", "Description"})
in
    #"Removed Other Columns"