host: redshift-cluster-1.******.redshift.amazonaws.com
port: 5439
user: awsuser
password: Mypassword123
database: asm3_dw_dbo

1. Download datasets: https://drive.google.com/drive/folders/1qvFgXWDQE9iZW7bctwA3HJys6O89_qTR
- netflix_titles.csv
- extra_data.csv
Data in dataset:
- show_id - INT
- type - VARCHAR(255)
- title - NVARCHAR(255)
- director - NVARCHAR(255)
- cast  - NVARCHAR(2000)
- country - VARCHAR(255)
- date_added - VARCHAR(255)
- release_year  - VARCHAR(255)
- rating - VARCHAR(255)
- duration - VARCHAR(255)
- listed_in - NVARCHAR(255)
- description - NVARCHAR(1000)

2. Import Dataset into SQL Server
You need to download a Dataset containing information about movies on Netflix, then import that data into the ASM3_Source.netflix_shows table.
![image](https://user-images.githubusercontent.com/108084669/218794586-8165fbf1-b783-4186-8444-012b51c82552.png)

3. Create SSIS to make ETL load data from Data Source into Data Warehouse
![image](https://user-images.githubusercontent.com/108084669/218794805-81783cc2-2b9b-4151-a762-a26876213b43.png)

After running ETL, the data in the Data Warehouse will be imported as follows:
![image](https://user-images.githubusercontent.com/108084669/218794938-4d6545ce-c918-47c7-a7ee-5099dec20b54.png)

4. Convert the newly created ETL from SSIS to T-SQL ETL
See "T-SQL ETL Query_On-Premises.sql"

5. Create a Redshift Cluster as Cloud Data Warehouse
![image](https://user-images.githubusercontent.com/108084669/218795676-38d1a13a-8bb7-4b9b-bd64-4e63c7135c9e.png)

6. Use Amazon SCT tool to convert Schema between SQL Server and Redshift
![image](https://user-images.githubusercontent.com/108084669/218795850-3eb2b718-38a4-4f7e-98a0-18ed1fc4c2eb.png)

7. Migrate data of On-premises Data Warehouse to Cloud Data Warehouse
Once the data has been brought from the Source into the On-Premises DW, you will need to migrate the data to Redshift. This request will include the following steps:

Step 1: Export data from SQL Server as csv file.
Step 2: Upload those csv files to S3 Bucket.
Step 3: Use the S3Copy statement to import data from S3 Bucket into Redshift. This command will look like this:

COPY table_name (col1, col2, col3, col4)
FROM 's3://<your-bucket-name>/load/file_name.csv'
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>'
CSV
INGOREHEADER 1;




