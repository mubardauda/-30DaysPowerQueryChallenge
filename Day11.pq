/* Problem Challenge

Instructions:
Select [City], [CountryRegionCode] and [EnglishCountryRegionName] where no [SalesAmount] occurred.
Sort [CountryRegion] and [City] in Ascending Order.
*/

//MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimGeography = Source{[Schema="dbo",Item="DimGeography"]}[Data],
    #"Expanded DimCustomer" = Table.ExpandTableColumn(dbo_DimGeography, "DimCustomer", {"FactInternetSales"}, {"DimCustomer.FactInternetSales"}),
    #"Expanded DimCustomer.FactInternetSales" = Table.ExpandTableColumn(#"Expanded DimCustomer", "DimCustomer.FactInternetSales", {"SalesAmount"}, {"SalesAmount"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded DimCustomer.FactInternetSales", each ([SalesAmount] = null)),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"City", "CountryRegionCode", "EnglishCountryRegionName"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns", {"City"}),
    #"Sorted Rows" = Table.Sort(#"Removed Duplicates",{{"CountryRegionCode", Order.Ascending}, {"City", Order.Ascending}})
in
    #"Sorted Rows"


//SOLUTION TO THE CHALLENGE
https://github.com/itsnotaboutthecell/powerquerym/blob/master/%2330DQUERY/Day%20011.pq

let
	Source = Sql.Databases("MUBAR\SQLEXPRESS"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_DimCustomer = AdventureWorksDW2017{[Schema = "dbo", Item = "DimGeography"]}[Data],
	#"Expanded DimCustomer" = Table.ExpandTableColumn(
		dbo_DimCustomer, 
		"DimCustomer", 
		{"FactInternetSales"}, 
		{"FactInternetSales"}
	),
	#"Expanded FactInternetSales" = Table.ExpandTableColumn(
		#"Expanded DimCustomer", 
		"FactInternetSales", 
		{"SalesAmount"}, 
		{"SalesAmount"}
	),
	#"Filtered Rows" = Table.SelectRows(#"Expanded FactInternetSales", each ([SalesAmount] = null)),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Filtered Rows", 
		{"City", "CountryRegionCode", "EnglishCountryRegionName"}
	),
	#"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
	#"Sorted Rows" = Table.Sort(
		#"Removed Duplicates", 
		{{"CountryRegionCode", Order.Ascending}, {"City", Order.Ascending}}
	)
in
	#"Sorted Rows"