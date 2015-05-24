This program allows you to store in a MySQL database texts and comments of ".doc files" saved within a folder. The program also works with folders nested in several levels.

1)Before running the program you need to create a database named "doc_db":
	CREATE DATABASE doc_db;

2)The program uses the following data for MySql access:
	user: script
	pass: password
so create a user like this or change the source code where needed to use a different user.

3)Make sure that the user has permissions to modify the database: GRANT ALL ON doc_db.* to script@localhost;
