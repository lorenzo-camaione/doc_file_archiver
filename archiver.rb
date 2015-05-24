
require 'yomu'

puts "Type the folder path:"
path = gets.chomp

directory = Dir["#{path}/**/*.doc"]

i=1

directory.each do |f|
	yomu = Yomu.new "#{f}"
	text = yomu.text.gsub(/["]/, "'")
	comment = yomu.metadata['Comments'].gsub(/["]/, "'")
	
	
	require 'mysql'

	begin
		#script-->user, password--> password of 'script' user, ustica--> database name
		con = Mysql.new 'localhost', 'script', 'password', 'ustica'
		
		input = "INSERT INTO ustica_doc (file_name, doc_text, doc_comment) VALUES(\"#{f}\", \"#{text}\", \"#{comment}\");"
		con.query(input)
		
		puts "#{i}) #{f} -->done"
		i+=1
	
		rescue Mysql::Error => e
			puts e.errno
			puts e.error
	    
		ensure
			con.close if con
	end

end





