/* Problem Challenge:

Instructions:
Select the [EmployeeKey], [Gender], [BirthDate] and a new merged [FullName] column which is a 
concatenation of [FirstName], [MiddleName] and [LastName] with a space separator for all employees with a [BirthDate] in the year 1974.
*/

// MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimEmployee = Source{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(dbo_DimEmployee,{"EmployeeKey", "FirstName", "LastName", "MiddleName", "BirthDate", "Gender"}),
    #"Merged Columns" = Table.CombineColumns(#"Removed Other Columns",{"FirstName", "MiddleName", "LastName"},Combiner.CombineTextByDelimiter(" ", QuoteStyle.None),"Full Name"),
    #"Inserted Year" = Table.AddColumn(#"Merged Columns", "Year", each Date.Year([BirthDate]), Int64.Type),
    #"Filtered Rows" = Table.SelectRows(#"Inserted Year", each ([Year] = 1974)),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"Year"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns", {"Full Name"})
in
    #"Removed Duplicates"
