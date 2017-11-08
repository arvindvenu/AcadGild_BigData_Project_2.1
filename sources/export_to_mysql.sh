# running the pig job for all 4 tasks in the project
# all outputs will be written to /user/arvind/projects/acadgild/project_2.1/output/
# HDFS directory. sub folders for each task will be created under the above directory
pig /home/arvind/projects/acadgild/project_2.1/sources/project_2.1.pig; 

# creating tables in MySQL to export the data to
mysql -u root -p < /home/arvind/projects/acadgild/project_2.1/sources/create_tables.sql;

# deleting the _SUCCESS file beacuse it is not needed
hadoop fs -rm /user/arvind/projects/acadgild/project_2.1/output/task_1/_SUCCESS;
# export the data to a table named task_1
sqoop export --connect jdbc:mysql://localhost:3306/project_2.1 \
--username root \
--P \
--table task_1 \
--export-dir /user/arvind/projects/acadgild/project_2.1/output/task_1 \
--input-fields-terminated-by '\t' \
--columns 'description,count';

# deleting the _SUCCESS file beacuse it is not needed
hadoop fs -rm /user/arvind/projects/acadgild/project_2.1/output/task_2/_SUCCESS;
# export the data to a table named task_2
sqoop export --connect jdbc:mysql://localhost:3306/project_2.1 \
--username root \
--P \
--table task_2 \
--export-dir /user/arvind/projects/acadgild/project_2.1/output/task_2 \
--input-fields-terminated-by '\t' \
--columns 'description,count';

# deleting the _SUCCESS file beacuse it is not needed
hadoop fs -rm /user/arvind/projects/acadgild/project_2.1/output/task_3/_SUCCESS;
# export the data to a table named task_3
sqoop export --connect jdbc:mysql://localhost:3306/project_2.1 \
--username root \
--P \
--table task_3 \
--export-dir /user/arvind/projects/acadgild/project_2.1/output/task_3 \
--input-fields-terminated-by '\t' \
--columns 'company,complaint_count';

# deleting the _SUCCESS file beacuse it is not needed
hadoop fs -rm /user/arvind/projects/acadgild/project_2.1/output/task_4/_SUCCESS;
# export the data to a table named task_4
sqoop export --connect jdbc:mysql://localhost:3306/project_2.1 \
--username root \
--P \
--table task_4 \
--export-dir /user/arvind/projects/acadgild/project_2.1/output/task_4 \
--input-fields-terminated-by '\t' \
--columns 'description,count';
