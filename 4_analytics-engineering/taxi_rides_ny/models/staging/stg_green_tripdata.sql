{{
    config(
        materialized='view'
    )
}}
 
with tripdata as 
(
  select *,
    row_number() over(partition by "VendorID", lpep_pickup_datetime) as rn
  from {{ source('staging','green_taxi_trips') }}
  where {{ dbt.safe_cast('"VendorID"', api.Column.translate_type('integer')) }} is not null
)
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['"VendorID"', 'lpep_pickup_datetime']) }} as tripid,
    {{ dbt.safe_cast('"VendorID"', api.Column.translate_type('integer')) }} as vendorid,
    {{ dbt.safe_cast('"RatecodeID"', api.Column.translate_type('integer')) }} as ratecodeid,
    {{ dbt.safe_cast('"PULocationID"', api.Column.translate_type('integer')) }} as pickup_locationid,
    {{ dbt.safe_cast('"DOLocationID"', api.Column.translate_type('integer')) }} as dropoff_locationid,
    
    -- timestamps
    cast(lpep_pickup_datetime as timestamp) as pickup_datetime,
    cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime,
    
    -- trip info
    store_and_fwd_flag,
    {{ dbt.safe_cast("passenger_count", api.Column.translate_type("integer")) }} as passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    {{ dbt.safe_cast("trip_type", api.Column.translate_type("integer")) }} as trip_type,

    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(ehail_fee as numeric) as ehail_fee,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    coalesce({{ dbt.safe_cast("payment_type", api.Column.translate_type("integer")) }},0) as payment_type,
    {{ get_payment_type_description("payment_type") }} as payment_type_description
from tripdata
where rn = 1

{% if var('is_test_run', default=false) %}
  limit 100
{% endif %}
