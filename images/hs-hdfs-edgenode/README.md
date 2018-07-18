# HDFS Edgenode
An image built on top of `hshekhar47/hdfs-core` and has configurations for hadoop edgenode.

Edgenode nodes are the interface between the Hadoop cluster and the outside network. Edge nodes are used to run client applications and cluster administration tools.

# Spark
<img src='../resources/icons/spark.png' height='100'>
Spark provides a simple and expressive programming model that supports a wide range of applications, including ETL, machine learning, stream processing, and graph computation.

Once cluster is up spark history server can be acccessed over `http://hdfs-namenode:8080`

## Spark Shell
```bash
spark-shell
```
## Sprk Submit
Run below command and verify the spark jobs on http://hdfs-namenode:8080
```bash
spark-submit \
    --class org.apache.spark.examples.SparkPi \
    $SPARK_HOME/examples/jars/spark-examples_2.11-2.3.0.jar 10
```

-----------------------------------------

# Hive
<img src='../resources/icons/hive.png' height='100'>
A data warehouse infrastructure that provides data summarization and ad hoc querying.

## Hive shell
##### Connect to database using hive shell
```bash
deployer@hdfs-namenode:~$ hive
hive> show databases;
```

## Beeline shell
##### Connect to database using beeline
```bash
deployer@hdfs-namenode:~$ beeline -u 'jdbc:hive2://hdfs-edgenode:10000'
0: jdbc:hive2://localhost:10000>
```

## Working with hive database
##### Create hive table 
```sql
use default;
create table ratings(
    user_id int, 
    movie_id int, 
    rating int, 
    epoch string) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```
##### Loading data into hive table
```sql
LOAD DATA INPATH '/user/deployer/u.data' 
    OVERWRITE INTO TABLE ratings;
```
##### Query data from hive table
```sql
SELECT * FROM ratings LIMIT 10; 
```
### Working with partition
Lets say we have a usecase where similar data file is originated from various source (us_users, gb_users) or dataset generate daily (2018_01_01_records 2018_01_02_records) then we would want to keep a single table and create a column to partition the data (by country or date)
##### Creating table with partitions
```bash
0: jdbc:hive2://localhost:10000> create external table user_activity(
    username string,
    message string
) 
partition by(date_on string)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
STORED AS TEXTFILE
LOCATION '<hdfs location where textfile will be created>';
```
Now a column `date_on` will also be created in the user_activity table and while loading the value of this partition column has to be provided explicitely.
##### Loading data into table with partition information
```bash
LOAD DATA INPATH '/user/deployer/user_activity_20180101'
    OVERWRITE INTO TABLE user_activity 
    PARTITION(date_on='2018-01-01');

LOAD DATA INPATH '/user/deployer/user_activity_20180102'
    OVERWRITE INTO TABLE user_activity 
    PARTITION(date_on='2018-01-02');
```
-----------------------------------------

# SQOOP
<img src='../resources/icons/sqoop.png' height='100'>
Apache Sqoop is a tool designed for efficiently transferring bulk data between Apache Hadoop and structured datastores such as relational databases.

## SQOOP Import
### Import data into hdfs
```bash
sqoop import \
    --connect jdbc:mysql://<db hostname>/<db name> \
    --username <db_username> \
    --password <db_password> \
    --table <tbl_name> \
    --m 1
```
<p>Once above command is ran the hive table directory will be created in hdfs `/user/deployer/tbl_name`.</p>

### Import data into hive
```bash
sqoop import \
    --connect jdbc:mysql://<db hostname>/<db name> \
    --username <db_username> \
    --password <db_password> \
    --table <table_name> \
    --m 1
    --hive-import
```
Once above command is ran the hive table directory will be created in hdfs `/user/hive/warehouse/tbl_name`.

## SQOOP Export
#### Step 1: Create destination DATABASE,TABLE, GRANTS in external mysql instance
#### Step 2: Export hive table data to destination table
```bash
sqoop export \
    --connect jdbc:mysql://<db hostname>/<db name> \
    --username <db_username> \
    --password <db_password> \
    --table <destination table name> \
    --export-dir <hive table location> \
    --input-fields-terminated-by "\0001" \
    --m 1 \
```
**Note**: To export only selected  columns from source hive table to destination table we can use `--columns` parameter with , separated column names. Provided column names in hive and destination tables are identical.

-----------------------------------------


# Interfaces
 - Hadoop Portal `http://hdfs-namenode:50070`
 - Yarn Job History Portal `http://hdfs-namenode:8088`
 - MapReduce Job History Portal `http://hdfs-namenode:19888`
 - Spark Master Web UI `http://hdfs-namenode:8080` 

 # References
 - [Configure MySQL as Hive Metastore](https://dwbi.org/etl/bigdata/190-configuring-mysql-as-hive-metastore)
