
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

-- {{ config(materialized='table') }}

-- select * from dbo.imported_data where totaltransactionqty >= 10

  if object_id ('dbo."imported_data__dbt_tmp_temp_view"','V') is not null
      begin
      drop view dbo."imported_data__dbt_tmp_temp_view"
      end




  if object_id ('dbo."imported_data__dbt_tmp"','U') is not null
      begin
      drop table dbo."imported_data__dbt_tmp"
      end


   EXEC('create view dbo."imported_data__dbt_tmp_temp_view" as

with __dbt__cte__imported_data_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "Airbyte".dbo._airbyte_raw_imported_data
select
    json_value(_airbyte_data, ''$."DateTime"'') as datetime,
    json_value(_airbyte_data, ''$."SiteCode"'') as sitecode,
    json_value(_airbyte_data, ''$."TotalTransactionQty"'') as totaltransactionqty,
    json_value(_airbyte_data, ''$."TotalTransactionValue"'') as totaltransactionvalue,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    SYSDATETIME() as _airbyte_normalized_at
from "Airbyte".dbo._airbyte_raw_imported_data as table_alias
-- imported_data
where 1 = 1
),  __dbt__cte__imported_data_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__imported_data_ab1
select
    cast(datetime as
    NVARCHAR(max)) as datetime,
    cast(sitecode as
    NVARCHAR(max)) as sitecode,
    cast(totaltransactionqty as
    float
) as totaltransactionqty,
    cast(totaltransactionvalue as
    float
) as totaltransactionvalue,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    SYSDATETIME() as _airbyte_normalized_at
from __dbt__cte__imported_data_ab1
-- imported_data
where 1 = 1
),  __dbt__cte__imported_data_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__imported_data_ab2
select
    convert(varchar(32), HashBytes(''md5'',  coalesce(cast(



    concat(concat(coalesce(cast(datetime as
    NVARCHAR(max)), ''''), ''-'', coalesce(cast(sitecode as
    NVARCHAR(max)), ''''), ''-'', coalesce(cast(totaltransactionqty as
    NVARCHAR(max)), ''''), ''-'', coalesce(cast(totaltransactionvalue as
    NVARCHAR(max)), ''''),''''), '''') as
    NVARCHAR(max)), '''')), 2) as _airbyte_imported_data_hashid,
    tmp.*
from __dbt__cte__imported_data_ab2 tmp
-- imported_data
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__imported_data_ab3
select
    datetime,
    sitecode,
    totaltransactionqty,
    totaltransactionvalue,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    SYSDATETIME() as _airbyte_normalized_at,
    _airbyte_imported_data_hashid
from __dbt__cte__imported_data_ab3
-- imported_data from "Airbyte".dbo._airbyte_raw_imported_data
where 1 = 1
    ');

   SELECT * INTO "Airbyte".dbo."imported_data__dbt_tmp" FROM
    "Airbyte".dbo."imported_data__dbt_tmp_temp_view"



  if object_id ('dbo."imported_data__dbt_tmp_temp_view"','V') is not null
      begin
      drop view dbo."imported_data__dbt_tmp_temp_view"
      end


  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_imported_data__dbt_tmp_cci'
        AND object_id=object_id('dbo_imported_data__dbt_tmp')
    )
  DROP index dbo.imported_data__dbt_tmp.dbo_imported_data__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_imported_data__dbt_tmp_cci
    ON dbo.imported_data__dbt_tmp