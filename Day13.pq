/* Problem Challenge

Instructions:
Select [EmailAddress], [Gender], [BirthDate] for all employees with a [BirthDate] between 19900101 and 19901231
*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    Dim_Employee = Source{[Schema = "dbo", Item = "DimEmployee"]}[Data],
    #"Select Column" = Table.SelectColumns(Dim_Employee, {"EmailAddress", "Gender", "BirthDate"}),
    #"Filtered Rows" = Table.SelectRows(#"Select Column", each [BirthDate] >= #date(1990, 1, 1) and [BirthDate] <= #date(1990, 12, 31))
in
    #"Filtered Rows"