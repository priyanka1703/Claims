class AdminMailer < ApplicationMailer
	default from: "no-reply@mapunity.com"
	
	def send_remainder_user(u)
		mail(to: u.email, subject: "remainder")
	end

	def send_remainder_admin(u)
		mail(to: u.email, subject: "remainder")
	end
		
end
