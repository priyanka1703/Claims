require 'csv'
namespace :import1 do

     task claims: :environment do
        filename=File.join Rails.root, "myclaims.csv"
        counter=0; 
 	CSV.foreach(filename) do |row|
           
           id,title,exp_date,amount,summary, created_at,updated_at,user_id,status,dummy1,reiumbersed_at=row
           if status=="t"
              status= "Paid"
           else
              status= "Unpaid"
           end   
     
          claim= Claim.create(id: id,title: title,exp_date: exp_date,amount: amount,summary: summary, created_at: created_at,updated_at: updated_at,user_id: user_id,status: status,reiumbersed_at: reiumbersed_at)	 
         puts "#{claim.errors.full_messages.join(",")}" if claim.errors.any?
         counter+=1 if claim.persisted?
         end
        puts counter
     end

end
