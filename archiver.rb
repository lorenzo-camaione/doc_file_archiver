#Collaborators: Federico Cioschi, Lorenzo Camaione, Marcello Pichini, Vasco Coelho


require 'yomu'
require 'mysql'

begin
	#script-->user, password--> password of 'script' user, doc_db--> database name
	con = Mysql.new 'localhost', 'script', 'password', 'doc_db'
	
	table_check = con.query("SHOW TABLES LIKE \"doc_table\";")
	if table_check.num_rows==0
		con.query("CREATE TABLE doc_table(id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, file_name varchar(255), doc_text text, doc_comment text, double_doc boolean);")
		puts "\"doc_table\" created\n"
	end

	puts "Type the folder path:"
	path = gets.chomp

	directory = Dir["#{path}/**/*.doc"]

	i=1

	directory.each do |f|
		yomu = Yomu.new "#{f}"
		text = yomu.text.gsub('"', '\"')
		comment = yomu.metadata['Comments'].gsub('"', '\"')
		double = 0  #variable for the control of comments repetition
		
		comment_check = con.query("SELECT id FROM doc_table WHERE doc_comment=\"#{comment}\";")
		if comment_check.num_rows!=0
			double = 1
		end
		
		input = "INSERT INTO doc_table (file_name, doc_text, doc_comment, double_doc) VALUES(\"#{f}\", \"#{text}\", \"#{comment}\", \"#{double}\");"
		con.query(input)
		
		print "#{i}) #{f} "
		
		if double == 1
			puts "--> double"
		else
			puts "--> done"
		end
		
		i+=1
	
	end

	rescue Mysql::Error => e
		puts e.errno
		puts e.error
    
	ensure
		con.close if con
end



