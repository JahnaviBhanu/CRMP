CREATE DATABASE crmp_db;
USE crmp_db;


-- Users Table(users)

Id	int	NO	PRI		auto_increment
Username	varchar(20)	YES	UNI		
Password	varchar(64)	NO			
role	varchar(20)	YES		user	
Email	varchar(100)	YES			
reset_token	varchar(100)	YES			
reset_expiry	datetime	YES			
profile_pic	varchar(255)	YES			
about	varchar(255)	YES			
Status	varchar(200)	YES			
hashed_password	varchar(255)	YES			

---- Requests Table(requests)
req_id	int	NO	PRI		auto_increment
request_title	varchar(200)	YES			
request_desc	varchar(500)	YES			
department	varchar(50)	YES			

-- Logs Table(user_logs)
log_id	int	NO	PRI		auto_increment
username	varchar(100)	YES			
action	varchar(100)	YES			
request_id	int	YES			
details	varchar(255)	YES			
timestamp	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED


-- Customers Table(customers)

id	int	NO	PRI		auto_increment
name	varchar(100)	YES	UNI		
email	varchar(100)	YES			
phone	varchar(20)	YES			

-- Report Downloads Table
CREATE TABLE download_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    downloaded_at DATETIME NOT NULL
);