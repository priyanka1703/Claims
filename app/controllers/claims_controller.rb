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
               unless params[:bills].nil?
	                params[:bills][:file].each do |a|
                                logger.info "hhhhhhhhh"
	                	@bill = @claim.bills.create!(:file => a, :claim_id => @claim.id)
	                end
	            end 
		 redirect_back_or_default("/users/show") 
                
                
	
         else
		render 'new'
	
        end
	end


	def edit  
	
	end

	def update
		
		@claim = Claim.find(params[:id])
    		if @claim.update_attributes(claim_params)
                   
                  


                   #create new attachments
                   unless params[:bills].nil?
	                params[:bills][:file].each do |a|
	                	@bill = @claim.bills.create(:file => a, :claim_id => @claim.id)
	                end
	            end 
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
     
    unless params[:claims].nil?


    params[:claims].each do |id|
       claim_id = id
      c = Claim.find_by_id(claim_id)
        #code to update the status here
         c.status="Paid"
          c.reiumbersed_at=Time.current 
               
              if c.save
                 flash[:notice] = "Claims Paid"
                redirect_back_or_default("/claims") and return
                
              else
                 flash[:notice] = "Unable to pay Claims"
              end  
        end 

    else
      
       flash[:notice] = "Please select claims to pay"      
        redirect_back_or_default("/claims") and return
                
   end
     
end

    
=begin              


              @claim = Claim.find(params[:id])
              @claim.status="Paid"
              @claim.reiumbersed_at=Time.current 
               
              if @claim.save
                 redirect_to '/claims'
              else
                 flash[:notice] = "Unable to pay Claim"
              end  

=end

        

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
		params.require(:claim).permit(:title, :summary, :amount, :date_expenditure, bills_attributes: [:id, :claim_id, :file])
	end
end
