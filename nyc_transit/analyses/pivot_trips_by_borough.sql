-- Write a query to pivot the results by borough
-- The output will be like boroughA | boroughB |...
--                         1234     | 1234     |...

select
    {{ dbt_utils.pivot(
      'pickup_borough',
      dbt_utils.get_column_values(ref('mart__fact_trips_by_borough'), 'pickup_borough'),
      then_value='total_trips'
    ) }}
from {{ ref('mart__fact_trips_by_borough') }}