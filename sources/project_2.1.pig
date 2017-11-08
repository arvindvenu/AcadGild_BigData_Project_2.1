-- register the piggybank.jar for the CSVExcelStorage function
REGISTER '/home/arvind/pig/pig-0.17.0/lib/piggybank.jar';

-- load the comsumer complaint data set using CsvExcelStorage
cmp_data = LOAD '/user/arvind/projects/acadgild/project_2.1/input' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (date_recd:chararray,prod_type:chararray,sub_prod_type:chararray,issue:chararray,
sub_issue:chararray,consumer_comp:chararray, cmp_public_resp:chararray, company:chararray,
state:chararray, zip_code:chararray, submitted_via:chararray, date_sent:chararray, cmp_consumer_resp:chararray, timely_resp:chararray, consumer_disputed:chararray, complaint_id:chararray);

---------------------------------- Task 1 ------------------------------------
-- Filter for those tuples whose timely_resp = 'YES'
cmp_data_timely_resp = FILTER cmp_data BY UPPER(timely_resp) == 'YES';
-- Grouping all tuples filtered in the previous step into one inner bag to calculate the count
cmp_data_timely_resp_grouped = GROUP cmp_data_timely_resp ALL;
-- Calculate the count of tuples filtered
cmp_data_timely_resp_count = FOREACH cmp_data_timely_resp_grouped GENERATE 'Count for complaints with timely response',COUNT(cmp_data_timely_resp) AS count;
-- write the result to HDFS as a tab separated file
STORE cmp_data_timely_resp_count INTO '/user/arvind/projects/acadgild/project_2.1/output/task_1' USING PigStorage('\t');

---------------------------------- Task 2 ------------------------------------
-- Filter for those tuples whose date received and date sent are same
-- ToDate function is used to convert a string to Date object
cmp_data_same_day = FILTER cmp_data BY ToDate(date_recd,'MM/dd/yyyy') == ToDate(date_sent,'MM/dd/yyyy');
-- Grouping all tuples filtered in the previous step into one inner bag to calculate the count
cmp_data_same_day_grouped = GROUP cmp_data_same_day ALL;
-- Calculate the count of tuples filtered
cmp_data_same_day_count = FOREACH cmp_data_same_day_grouped GENERATE 'Count for complaints which were forwarded on the same day as received', COUNT(cmp_data_same_day) AS count;
-- write the result to HDFS as a tab separated file
STORE cmp_data_same_day_count INTO '/user/arvind/projects/acadgild/project_2.1/output/task_2' 
	USING PigStorage('\t');

---------------------------------- Task 3 ------------------------------------
-- grouping by company because we have the count of complaints by company and
-- find the company with max number of complaints
cmp_data_grouped_by_cmp = GROUP cmp_data BY company PARALLEL 2;
-- calculate the count per company
cmp_data_complaint_count = FOREACH cmp_data_grouped_by_cmp GENERATE group as company, 
			COUNT(cmp_data) AS complaint_count;
-- order the tuples in descending order of count
cmp_data_complaint_count_ordered = ORDER cmp_data_complaint_count BY complaint_count DESC;
-- Limit the number of tuples to 1 in the sorted bag  to find the company having the max complaints
cmp_data_top_complaint = LIMIT cmp_data_complaint_count_ordered 1;
-- write the result to HDFS as a tab separated file
STORE cmp_data_top_complaint INTO '/user/arvind/projects/acadgild/project_2.1/output/task_3' 
	USING PigStorage('\t');

---------------------------------- Task 4 ------------------------------------
-- Filter for those tuples whose product type is Debt collection and year is 2015
-- ToDate function is used to convert a string to Date object and GetYear is used to 
-- extract the year component from a date
cmp_data_debt_2015 = FILTER cmp_data BY UPPER(prod_type) == 'DEBT COLLECTION' AND 
			GetYear(ToDate(date_recd,'MM/dd/yyyy')) == 2015;
-- Grouping all tuples filtered in the previous step into one inner bag to calculate the count
cmp_data_debt_2015_grouped = GROUP cmp_data_debt_2015 ALL;
-- Calculate the count of tuples filtered
cmp_data_debt_2015_count = FOREACH cmp_data_debt_2015_grouped GENERATE 'Count for product type  Debt Collection in year 2015', COUNT(cmp_data_debt_2015) AS count;
-- write the result to HDFS as a tab separated file
STORE cmp_data_debt_2015_count INTO '/user/arvind/projects/acadgild/project_2.1/output/task_4' 
	USING PigStorage('\t');
