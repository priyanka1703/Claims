scheduler = Rufus::Scheduler.new
@users=User.all

scheduler.every("40m") do
        @users.each do |u|
	    AdminMailer.send_remainder_user(u).deliver
        end   
end 


   scheduler.every("40m") do
if  Claim.find {|s| s.status == 'Unpaid' }   
     @users.each do |u|
		if u.admin?
	    		AdminMailer.send_remainder_admin(u).deliver
        	end 
	end  	
   end 
end


=begin
scheduler.cron("0 0 12 ? * MON") do
        @users.each do |u|
	    AdminMailer.send_remainder_user(u).deliver
        end   
end 


   scheduler.cron("0 0 12 1 1/12 ?") do
if  Claim.find {|s| s.status == 'Unpaid' }   
     @users.each do |u|
		if u.admin?
	    		AdminMailer.send_remainder_admin(u).deliver
        	end 
	end  	
   end 
end
=end
