/* Problem Challenge

Instructions:
Select [Gender], [EnglishEducation] and pivot the sum of [OrderQuantity] for [CommuteDistance]. 
Sort the [EnglishEducation] from the lowest education level to the highest and the [Gender] column in ascending order.
Re-order the [CommuteDistance] columns from the shortest to longest distance.
*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimCustomer = Source{[Schema="dbo",Item="DimCustomer"]}[Data],
    #"Expanded FactInternetSales" = Table.ExpandTableColumn(dbo_DimCustomer, "FactInternetSales", {"OrderQuantity"}, {"OrderQuantity"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Expanded FactInternetSales",{"Gender", "EnglishEducation", "CommuteDistance", "OrderQuantity"}),
    #"Pivoted Column" = Table.Pivot(#"Removed Other Columns", List.Distinct(#"Removed Other Columns"[CommuteDistance]), "CommuteDistance", "OrderQuantity", List.Sum),
    #"Sorted Rows" = Table.Sort(#"Pivoted Column",{{"EnglishEducation", Order.Descending}, {"Gender", Order.Ascending}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Sorted Rows",{"Gender", "EnglishEducation", "0-1 Miles", "1-2 Miles", "2-5 Miles", "5-10 Miles", "10+ Miles"})
in
    #"Reordered Columns"
