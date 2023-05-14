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


//SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%2009.pq

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimCustomer = Source{[Schema="dbo",Item="DimCustomer"]}[Data],
    // dbo_DimCustomer
    // FactInternetSales
    FactInternetSales =Source{[Schema = "dbo", Item = "FactInternetSales"]}[Data],
    // Join Tables
    #"dbo_DimCustomer -> FactInterntSales" = Table.Join(
        dbo_DimCustomer, 
        "CustomerKey", 
        FactInternetSales, 
        "CustomerKey", 
        JoinKind.Inner
    ),
    #"Added Conditional Column" = Table.AddColumn(
        #"dbo_DimCustomer -> FactInterntSales", 
        "EducationSort", 
        each if [EnglishEducation] = "Partial High School"
            then 0
            else if [EnglishEducation] = "High School"
                then 1
                else if [EnglishEducation] = "Partial College"
                    then 2
                    else if [EnglishEducation] = "Bachelors"
                        then 3
                        else if [EnglishEducation] = "Graduate Degree" then 4 else null, 
        Int64.Type
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Added Conditional Column", {
        "Gender", 
        "EnglishEducation", 
        "CommuteDistance", 
        "OrderQuantity", 
        "EducationSort"
    }),
    CommuteDistances = List.Distinct(#"Removed Other Columns"[CommuteDistance]),
    ReorderCommute = List.Combine({
        List.Sort(List.Select(CommuteDistances, each _ <> "10+ Miles")), 
        List.Select(CommuteDistances, each _ = "10+ Miles")
    }),
    #"Pivoted Column" = Table.Pivot(
        #"Removed Other Columns", 
        ReorderCommute, 
        "CommuteDistance", 
        "OrderQuantity", 
        List.Sum
    ),
    #"Sorted Rows" = Table.Sort(#"Pivoted Column", {
        {"EducationSort", Order.Ascending}, 
        {"Gender", Order.Ascending}
    }),
    #"Removed Columns" = Table.RemoveColumns(#"Sorted Rows",{"EducationSort"})
in
    #"Removed Columns"