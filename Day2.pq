/* Problem Challenge:

Instructions:
Select the [ResellerKey], [BusinessType], [ResellerName], [NumberEmployees], [ProductLine],
[AnnualRevenue] and [EnglishCountryRegionName] columns where the [ResellerName] contains Bike or Bicycle and the [CountryRegionCode] is not in DE or GB.
*/
//NOTE: There is a merged column of DimReseller and DimGeography in the DimReseller Table. So I expand it, instead of creating a new merge for both table as instructed

// MY SOLUTION

let
    Source = Sql.Database("MUBAR\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimReseller = Source{[Schema = "dbo", Item = "DimReseller"]}[Data],
    #"Expanded DimGeography" = Table.ExpandRecordColumn(
        dbo_DimReseller,
        "DimGeography",
        {"CountryRegionCode", "EnglishCountryRegionName"},
        {"CountryRegionCode", "EnglishCountryRegionName"}
    ),
    #"Filtered Rows" = Table.SelectRows(
        #"Expanded DimGeography",
        each Text.Contains([ResellerName], "Bike") or Text.Contains([ResellerName], "Bicycle")
    ),
    #"Filtered Rows1" = Table.SelectRows(
        #"Filtered Rows", each ([CountryRegionCode] <> "DE" and [CountryRegionCode] <> "GB")
    ),
    #"Removed Other Columns" = Table.SelectColumns(
        #"Filtered Rows1",
        {
            "ResellerKey",
            "BusinessType",
            "ResellerName",
            "NumberEmployees",
            "ProductLine",
            "AnnualRevenue",
            "EnglishCountryRegionName"
        }
    )
in
    #"Removed Other Columns"