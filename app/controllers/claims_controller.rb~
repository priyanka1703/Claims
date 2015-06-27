class ClaimsController < ApplicationController
	before_filter :can_delete_or_edit?, :only => [:edit, :destroy]
	before_filter :check_admin?, :only => [:index, :pay]
	def index
             #@claims=Claim.all
        store_location
	@filterrific = initialize_filterrific(
		    Claim,
		    params[:filterrific],
                    select_options: {
		    sorted_by: Claim.options_for_sorted_by,
                    with_user_id: User.options_for_select					
			},
                     persistence_id: false
    		     
 
		  ) or return
		  @claims = @filterrific.find 
		  @claims = @claims.paginate(:page => params[:page], :per_page => 10)
                  
		  respond_to do |format|
		    format.html
		    format.js
		  end
	    rescue ActiveRecord::RecordNotFound => e
	    # There is an issue with the persisted param_set. Reset it.
	    puts "Had to reset filterrific params: #{ e.message }"
	    redirect_to(reset_filterrific_url(format: :html)) and return
	  end


	def new 
		@claim=Claim.new	
	end

	def create
	@claim=Claim.new(claim_params)
	@claim.exp_date= params[:date_expenditure][:year]+"/"+params[:date_expenditure][:month]+"/" + params[:date_expenditure][:day]
	
	@claim.status = "Unpaid"
	@claim.user=current_user
	if @claim.save
             
		redirect_to '/users/show'
	else
		render 'new'
	end
	end


	def edit  
	
	end

	def update
		
		@claim = Claim.find(params[:id])
    		if @claim.update_attributes(claim_params)
			flash[:notice] = "Claim updated"
			redirect_back_or_default("/users/show")
    		else
      			render 'edit'
    		end	
	end

	def destroy 
		
		if @claim.destroy
    			flash[:notice] = "Claim deleted"
			
				redirect_back_or_default("/users/show")
		else
			flash[:notice] = "Unable to delete Claim"
		end
	end

        def pay
              @claim = Claim.find(params[:id])
              @claim.status="Paid"
           
              if @claim.save
                 redirect_to '/claims'
              else
                 flash[:notice] = "Unable to pay Claim"
              end  
        end

	def can_delete_or_edit?
		@claim = Claim.find(params[:id])
		if @claim.status.downcase.eql?("paid") 
			flash[:notice] = "You can not edit or delete this!"	   		
			redirect_to root_url
			return;
		end	
	end

	def check_admin?
		if current_user && !current_user.admin?
			flash[:notice] = "You do not have permission to perform this action."
			redirect_to root_url
			return; 
		end
	end

	private
	def claim_params
		params.require(:claim).permit(:title, :summary, :amount, :date_expenditure, :file)
	end
end
