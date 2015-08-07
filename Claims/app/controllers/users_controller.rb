class UsersController < ApplicationController

before_filter :check_admin?, :only => [:index]
def show
    store_location
   #if params[:filterrific].nil?
   #     params[:filterrific]={"with_user_id" => current_user.id}
   #else
   #    params[:filterrific]["with_user_id"]=current_user.id
   #end   
  # @claims=current_user.claims
	@filterrific = initialize_filterrific(
		    Claim,
		    params[:filterrific],
                    select_options: {
		    sorted_by: Claim.options_for_sorted_by,
                   				
			},
                  
                   :persistence_id => false,
 
		  ) or return
		  @claims = @filterrific.find
                  @claims = @claims.where("user_id = ?", current_user.id)
		  @claims = @claims.paginate(:page => params[:page], :per_page => 10)
		  respond_to do |format|
		    format.html
		    format.js
		  end
	    rescue ActiveRecord::RecordNotFound => e
	    # There is an issue with the persisted param_set. Reset it.
	    puts "Had to reset filterrific params: #{ e.message }"
	    redirect_to(reset_filterrific_url(format: :html)) and return

	#current_user.update_attribute :admin, true
end


def index
 @users=User.all
end


def destroy
                #Claim.find_by_user_id(params[:id]).destroy
		if User.find(params[:id]).update_attribute(:active, false)
    			flash[:notice] = "User account deactivated"
		        redirect_to '/users'
	                
		else
			flash[:notice] = "Unable to deactivate User"
		end
end

def admin
              @user = User.find(params[:id])
         
              if @user.update_attribute(:admin, true)

                 redirect_to '/users'
              else
                 flash[:notice] = "Unable to make admin"
              end  
end

def check_admin?
		if current_user && !current_user.admin?
			flash[:notice] = "You do not have permission to perform this action."
			redirect_to root_url
			return; 
		end
	end

		
	
end
