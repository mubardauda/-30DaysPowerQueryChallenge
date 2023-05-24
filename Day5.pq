/* Problem Challenge

Instructions:
Select the [Employee Key], [Employee], [Is Salesperson], [Valid From] and [Valid To] where the following two conditions are met –
[Is Salesperson] is True, the [Valid To] year is not 9999 and the total days between [Valid From] and [Valid To] is greater than 365
[Is Salesperson] is False and the [Valid To] year is 9999*/


//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Dimension_Employee = Source{[Schema="Dimension",Item="Employee"]}[Data],
    //I didn't get my filtering well, so i need to look through the solution for answer
    /*#"Filtered Rows" = Table.SelectRows(Dimension_Employee,
            each ([Is Salesperson] = true and
            Date.Year[Valid To] <> 9999 and
            Duration.TotalDays([Valid To] - [Valid From]) > 365))*/
    #"Filtered Rows" = Table.SelectRows(
        Dimension_Employee, 
        each (Date.Year([Valid To]) <> 9999 and [Is Salesperson] = true and Duration.TotalDays(
            [Valid To] - [Valid From]
        )
            > 365)
            or ([Is Salesperson] = false and Date.Year([Valid To]) = 9999)
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{
        "Employee Key",
        "Employee",
        "Is Salesperson",
        "Valid From",
        "Valid To"
    })
in
    #"Removed Other Columns"
