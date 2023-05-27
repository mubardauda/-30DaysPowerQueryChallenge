/* Problem Challenge

Instructions:
Select the ten longest delivery days average for [City Key], [City] and the computed column [Average Delivery Days] which is the days between [Order Date Key] and [Delivery Date Key] for all completed deliveries.
Include ties if applicable.*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Fact_Sale = Source{[Schema="Fact",Item="Sale"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(Fact_Sale,{"Sale Key", "City Key", "Delivery Date Key"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each ([Delivery Date Key] <> null)),
    #"Merged Queries" = Table.NestedJoin(#"Filtered Rows", {"Sale Key"}, #"Fact Order", {"Order Key"}, "Fact Order", JoinKind.Inner),
    #"Expanded Fact Order" = Table.ExpandTableColumn(#"Merged Queries", "Fact Order", {"Order Key", "Order Date Key"}, {"Order Key", "Order Date Key"}),
    #"Added Custom" = Table.AddColumn(#"Expanded Fact Order", "Custom", each Duration.TotalDays([Delivery Date Key] - [Order Date Key])),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Custom",{{"Custom", Int64.Type}}),
    #"Grouped Rows" = Table.Group(#"Changed Type", {"City Key"}, {{"Average Delivery Days", each List.Average([Custom]), type nullable number}}),
    #"Rounded Up" = Table.TransformColumns(#"Grouped Rows",{{"Average Delivery Days", Number.RoundUp, Int64.Type}}),
    #"Merged Queries1" = Table.NestedJoin(#"Rounded Up", {"City Key"}, #"DimCityW (2)", {"City Key"}, "DimCustomerW (2)", JoinKind.LeftOuter),
    #"Expanded DimCustomerW (2)" = Table.ExpandTableColumn(#"Merged Queries1", "DimCustomerW (2)", {"City"}, {"City"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Expanded DimCustomerW (2)",{"City Key", "City", "Average Delivery Days"}),
    #"Sorted Rows" = Table.Sort(#"Reordered Columns",{{"Average Delivery Days", Order.Descending}}),
    #"10th Value" = List.Sort(List.Distinct(#"Sorted Rows"[Average Delivery Days]), Order.Descending){10} - 1,
	#"Filter Top 10" = Table.SelectRows(#"Sorted Rows", each [Average Delivery Days] > #"10th Value"),
	#"Sorted Top10" = Table.Sort(#"Filter Top 10", {{"Average Delivery Days", Order.Descending}})
in
	#"Sorted Top10"