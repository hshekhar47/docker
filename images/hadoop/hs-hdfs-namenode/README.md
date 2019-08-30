# HDFS Namenode
An image built on top of `hshekhar47/hdfs-core` and has configurations for hadoop namenode.

# Services
## Running
    - HDFS
    - YARN
    - MR Job Histry Server
## Optional Services
#### HBASE
```bash
${HBASE_HOME}/bin/start-hbase.sh 
```
#### Spark Job History server
```bash
${SPARK_HOME}/sbin/start-history-server.sh
``` 

# Interfaces
- Hadoop Portal `http://hdfs-namenode:50070`
- MapReduce Job History Portal `http://hdfs-namenode:19888`
- Yarn Job History Portal `http://hdfs-namenode:8088`
- Spark Job History UI `http://hdfs-namenode:18080`