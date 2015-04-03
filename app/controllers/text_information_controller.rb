class TextInformationController < ApplicationController
  
  def index
    @meta_title = I18n.t 'meta_title.t_textpayinfo'
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
  end
  
  def textpay
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
        
     if request.post?
      
        if params[:tin_type] == "social_number1"
           @tin = params[:ssn1].to_s() + params[:ssn2].to_s() + params[:ssn3].to_s()     
        elsif params[:tin_type] == "employer_number1"
           @tin = params[:eno1].to_s() + params[:eno2].to_s()
         elsif params[:tin_type] == "employer_number"
           @tin = params[:enp1].to_s() + params[:enp2].to_s()
         elsif params[:tin_type] == "social_number"
            @tin = params[:essn1].to_s() + params[:essn2].to_s() + params[:essn3].to_s()
         end
         
        @taxpay = Textpay.find(:first, :conditions => ['user_id=?', session[:user_id]])
        
         
        if @taxpay && @taxpay!=''
          @taxpay.update_attributes(params[:textpay])
          @taxpay[:tin_no]=@tin 
          
        else
         @taxpay = Textpay.new(params[:textpay])    
         @taxpay[:tin_no]=@tin     
        end
                         
        @taxpay.save  
        
        UserMailer.taxpayer_notification(@user).deliver
        
        redirect_to :action => 'index'
     end
     
  end
end