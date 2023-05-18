/* Problem Challenge

Instructions:
Union select a [Full Name] column for each unique name in ascending order.
The [Full Name] field is an alias for the [Employee] and [Primary Contact] fields.
*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Dim_Employee = Source{[Schema = "Dimension", Item = "Employee"]}[Data][[Employee]],
    #"Appended Query" = Table.Combine({Dim_Employee, DimCustomer}),
    #"Removed Duplicates" = Table.Distinct(#"Appended Query")
in
    #"Removed Duplicates"


//SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%20012.pq

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "WideWorldImportersDW"),
    Dimension_Employee =
        Source{[
            Schema = "Dimension",
            Item = "Employee"
        ]}
            [Data]
            [[Employee]],
    Dimension_Customer =
        Source{[
            Schema = "Dimension",
            Item = "Customer"
        ]}
            [Data]
            [[Primary Contact]],
    #"Renamed Columns" =
        Table.RenameColumns(
            Dimension_Customer,
            {
                {
                    "Primary Contact",
                    "Employee"
                }
            }
        ),
    UnionNames =
        Table.Combine(
            {
                Dimension_Employee,
                #"Renamed Columns"
            }
        ),
    #"Removed Duplicates" = Table.Distinct(UnionNames),
    #"Sorted Rows" =
        Table.Sort(
            #"Removed Duplicates",
            {
                {
                    "Employee",
                    Order.Ascending
                }
            }
        )
in
    #"Sorted Rows"