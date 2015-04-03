class UserBankDetail < ActiveRecord::Base
   belongs_to :user
   attr_accessible  :user_id, :bank_name, :bank_branch, :bank_ifsc_code, :bank_account_holder, :bank_account_number
    
end