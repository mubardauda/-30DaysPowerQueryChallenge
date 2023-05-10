/* Problem Challenge

Instructions:
Dynamically select all the columns that do not contain the text ‘Key’.

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimEmployee = Source{[Schema="dbo",Item="DimEmployee"]}[Data],
    /* I tried using the combination of transformcolumn and splitter function i found on M code documentation but it's not working
    so i need to look through the solution after I can't figured it out for a day
    #"Dynamic Splitting" = Table.TransformColumnNames(dbo_DimEmployee, each
    Text.Combine(Splitter.SplitTextByCharacterTransition({"a".."z"}, {"A".."Z"})("Key"), " ")*/
    #"Non-Key Columns" = List.Select(Table.ColumnNames(dbo_DimEmployee), each not Text.Contains(
        _,
        "Key", 
        Comparer.Ordinal
    ))
in
    #"Non-Key Columns"


//SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%2007.pq

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimEmployee = Source{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Non-Key Columns" = List.Select(Table.ColumnNames(dbo_DimEmployee), each  not Text.Contains(
        _, 
        "Key", 
        Comparer.Ordinal
    ))
in
    #"Non-Key Columns"