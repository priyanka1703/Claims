class Claim < ActiveRecord::Base
 belongs_to :user
  has_many :bills
	
  validates :title, presence: true
  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
 validates :exp_date, presence: true 
  validates :file, :presence => true,
   :if => lambda {self.amount>1000}

	
filterrific(
  default_filter_params: {  },
  available_filters: [
    :sorted_by,
    :search_query,
    :with_user_id,
    :with_created_at_gte,
    :with_amount_gte,
    :with_status
  ]
)



def self.search_query(q)
   where("title ~* ?", q)
end


  scope :with_user_id, lambda { |user_ids|
     where(user_id: [*user_ids])    
  }


  scope :with_created_at_gte, lambda { |ref_date|
     where('claims.created_at >= ?', ref_date)
  }

 
  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
  case sort_option.to_s
  when /^created_at_/
    order("claims.created_at #{ direction }")
  when /^title_/
    order("LOWER(claims.title) #{ direction }")
  
  when /^amount_/
    order("(claims.amount) #{ direction }")
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}

  


  scope :with_amount_gte, lambda { |amount|
             where('claims.amount >= ?', amount)
  }


  scope :with_status, lambda { |status|
 		where(status: [*status])
 }


 def self.options_for_sorted_by
    [
      ['Amount (increasing)', 'amount_asc'],
      ['Amount (decreasing)', 'amount_desc'],
      ['Title (a-z)', 'title_asc'],
      ['Registration date (newest first)', 'created_at_desc'],
      ['Registration date (oldest first)', 'created_at_asc'],
     
    ]
  end


end


