CREATE DATABASE bank;
USE bank;

CREATE TABLE  accounts (
	account_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 	
	balance DOUBLE NOT NULL,    
	`type` VARCHAR(30) NOT NULL,
	date_opened DATETIME NOT NULL,
    `status` VARCHAR(30) NOT NULL
);

CREATE TABLE  transactions (
	transaction_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 	
	date_time DATETIME NOT NULL,    
	amount DOUBLE NOT NULL,
	remaining_balance DOUBLE NOT NULL,
    account_id INT NOT NULL
);

ALTER TABLE transactions	
ADD FOREIGN KEY (account_id)
REFERENCES accounts(account_id)
ON DELETE CASCADE	
ON UPDATE CASCADE;

INSERT INTO accounts (account_id, balance, `type`, date_opened, `status`)
VALUES (1001, 123.4, 'checking', '2001-01-01', 'activated'),
(1002, 1234.5, 'saving', '2002-02-02', 'activated'),
(1003, 12345.6, 'credit_card', '2003-03-03', 'unactivated');

SELECT * FROM accounts
ORDER BY date_opened DESC #descending
LIMIT 2;

INSERT INTO transactions (transaction_id, date_time, amount, remaining_balance, account_id)
VALUES (101, '2011-01-01', -23.4, 100.0, 1001);

INSERT INTO transactions (transaction_id, date_time, amount, remaining_balance, account_id)
VALUES (102, '2012-02-02', -234.5, 1000.0, 1002),
(103, '2013-03-03', -2300.0, 10045.6, 1003),
(104, '2014-04-04', -45.0, 10000.6, 1003),
(105, '2015-05-05', -0.6, 10000.0, 1003);

SELECT * FROM transactions
WHERE account_id = 1003
ORDER BY date_time ASC; #ascending

UPDATE accounts SET `status`= 'activated';

DELETE FROM transactions 
WHERE transaction_id = 102;