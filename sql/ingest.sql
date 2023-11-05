drop table if exists bike_data;
drop table if exists central_park_weather;
drop table if exists fhv_bases;
drop table if exists fhv_tripdata;
drop table if exists fhvhv_tripdata;
drop table if exists green_tripdata;
drop table if exists yellow_tripdata;

-- load location & weather data from CSV files, merging columns by name and storing as strings
create table fhv_bases as select * from  read_csv_auto('./data/fhv_bases.csv', union_by_name=True, filename=True, all_varchar=1, header=True);
create table central_park_weather as select * from read_csv_auto('./data/central_park_weather.csv', union_by_name=True, filename=True, all_varchar=1);

-- load taxi data from parquet files, merging columns by name
create table yellow_tripdata as select * from read_parquet('./data/taxi/yellow_tripdata.parquet', union_by_name=True, filename=True);
create table green_tripdata as select * from read_parquet('./data/taxi/green_tripdata.parquet', union_by_name=True, filename=True);
create table fhvhv_tripdata as select * from read_parquet('./data/taxi/fhvhv_tripdata.parquet', union_by_name=True, filename=True);
create table fhv_tripdata as select * from read_parquet('./data/taxi/fhv_tripdata.parquet', union_by_name=True, filename=True);

-- load bike data from CSV files, merging columns by name and storing as strings
create table bike_data as select * from read_csv_auto('./data/citibike-tripdata.csv.gz', union_by_name=True, filename=True, all_varchar=1);