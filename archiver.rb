#Collaborators: Federico Cioschi, Lorenzo Camaione, Marcello Pichini, Vasco Coelho


require 'yomu'
require 'mysql'

begin
	#script-->user, password--> password of 'script' user, doc_db--> database name
	con = Mysql.new 'localhost', 'script', 'password', 'doc_db'
	
	check = con.query("SHOW TABLES LIKE \"doc_table\";")
	if check.num_rows==0
		con.query("create table doc_table(id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, file_name varchar(255), doc_text text, doc_comment text);")
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
		
		
		input = "INSERT INTO doc_table (file_name, doc_text, doc_comment) VALUES(\"#{f}\", \"#{text}\", \"#{comment}\");"
		con.query(input)
		
		puts "#{i}) #{f} -->done"
		i+=1
	
	end

	rescue Mysql::Error => e
		puts e.errno
		puts e.error
    
	ensure
		con.close if con
end



