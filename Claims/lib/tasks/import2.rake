require 'csv'
namespace :import2 do

     task bills: :environment do
        filename=File.join Rails.root, "bills.csv"
        counter=0; 
        

     CSV.foreach(filename, col_sep: '|') do |row|
           
           #claim_id, remote_file_url, remote_file_url2=row  
	   claim_id = row[0]           
	   #remote_file_url="http://mapservices.in/"+remote_file_url
           bill_urls = row[1].split(";")
        

           bill_urls.each do |u|
         
            u="http://claims.mapservices.in"+u.strip
	    puts u
            bill= Bill.create(claim_id: claim_id, remote_file_url: u)
            puts "#{bill.errors.full_messages.join(",")}" if bill.errors.any?
           end
	   
         
          #counter+=1 if bill.persisted?
         
	end
        #puts counter
     end

end
