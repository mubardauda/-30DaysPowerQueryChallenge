/* Problem Challenge:

Instructions:
Select the [EmployeeKey], [Gender], [BirthDate] and a new merged [FullName] column which is a 
concatenation of [FirstName], [MiddleName] and [LastName] with a space separator for all employees with a [BirthDate] in the year 1974.
*/


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


/*Solution to Query Folding*/
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%2001.pq
 let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
    #"Added Custom" = Table.AddColumn(
        dbo_DimEmployee, 
        "FullName", 
        each if [BirthDate] >= #date(1974, 1, 1) and [BirthDate] < #date(1975, 1, 1) then [FirstName] & (if [MiddleName] = null then " " else " " & [MiddleName] & " ") & [LastName] else null, 
        type text
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Added Custom", {
        "EmployeeKey", 
        "BirthDate", 
        "Gender", 
        "FullName"
    })
in
    #"Removed Other Columns"