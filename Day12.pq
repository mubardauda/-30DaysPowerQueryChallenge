/* Problem Challenge

Instructions:
Union select a [Full Name] column for each unique name in ascending order.
The [Full Name] field is an alias for the [Employee] and [Primary Contact] fields.
*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Dim_Employee = Source{[Schema = "Dimension", Item = "Employee"]}[Data][[Employee]],
    Dimension_Customer = Source{[Schema = "Dimension", Item = "Customer"]}[Data][[Primary Contact]],
    #"Renamed Columns" = Table.RenameColumns(Dimension_Customer, {{"Primary Contact", "Employee"}}),
    #"Appended Query" = Table.Combine({Dim_Employee, #"Renamed Columns"}),
    #"Removed Duplicates" = Table.Distinct(#"Appended Query")
in
    #"Removed Duplicates"
