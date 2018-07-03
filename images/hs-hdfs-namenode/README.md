# HDFS Namenode
An image built on top of `hshekhar47/hdfs-core` and has configurations for hadoop namenode.

# Spark
<img src='../resources/icons/spark.png' height='100'>
<p>Spark provides a simple and expressive programming model that supports a wide range of applications, including ETL, machine learning, stream processing, and graph computation.</p>
Once cluster is up spark histry server can be acccessible over `http://localhost:18080`

## Spark Shell
```bash
spark-shell
```
## Sprk Submit
```bash
spark-submit \
    --deploy-mode client \
    --class org.apache.spark.examples.SparkPi \
    $SPARK_HOME/examples/jars/spark-examples_2.11-2.3.0.jar 10
```

# Hive
<img src='../resources/icons/hive.png' height='100'>
<p>A data warehouse infrastructure that provides data summarization and ad hoc querying.</p>

## Beeline
### Basic table creation and loading of data
##### Connect to database using beeline
```bash
$ beeline -u 'jdbc:hive2://localhost:10000'
0: jdbc:hive2://localhost:10000>
```
##### Create table 
```bash
0: jdbc:hive2://localhost:10000> create table ratings(
    user_id int, 
    movie_id int, 
    rating int, 
    epoch string) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' STORED AS TEXTFILE;
0: jdbc:hive2://localhost:10000> !sql desc ratings;
```
##### Loading data into table
```bash
0: jdbc:hive2://localhost:10000>LOAD DATA INPATH '/user/deployer/u.data' OVERWRITE INTO TABLE ratings;
```
##### Query data from table
```bash
0: jdbc:hive2://localhost:10000>!sql select * from ratings LIMIT 10; 
```
### Working with partition
Lets say we have a usecase where similar data file is originated from various source (us_users, gb_users) or dataset generate daily (2018_01_01_records 2018_01_02_records) then we would want to keep a single table and create a column to partition the data (by country or date)
##### Creating table with partitions
```bash
create external table user_activity(
    username string,
    message string
) partition by(date_on string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' STORED AS TEXTFILE
LOCATION '<hdfs location where textfile will be created>';
```
Now a column `date_on` will also be created in the user_activity table and while loading the value of this partition column has to be provided explicitely.
##### Loading data into table with partition information
```bash
LOAD DATA INPATH '/user/deployer/user_activity_20180101' OVERWRITE INTO TABLE user_activity PARTITION(date_on='2018-01-01');
LOAD DATA INPATH '/user/deployer/user_activity_20180102' OVERWRITE INTO TABLE user_activity PARTITION(date_on='2018-01-02');
```

# Interfaces
 - Hadoop Portal `http://hdfs-namenode:50070`
 - Yarn Portal `http://hdfs-namenode:8088`
 - Spark Portal `http://hdfs-namenode:18080`
 - Beeline jdbc `jdbc:hive2://hdfs-namenode:10000` 
