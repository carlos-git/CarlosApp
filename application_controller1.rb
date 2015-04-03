class ApplicationController < ActionController::Base
  #protect_from_forgery
  before_filter :configure_app
  before_filter :configure_lang
  
   # Override build_footer method in ActiveAdmin::Views::Pages
  require 'active_admin_views_pages_base.rb'
      
  protected
    def configure_app
       
          if (!params[:ret] || params[:ret]==nil || params[:ret]=='') && (session[:return_url_event]!='' && session[:return_url_event]!=nil)
            session[:return_to] = nil
            session[:return_url_event] = nil
          elsif (params[:ret]=='yes') && (session[:return_url_event]!='' && session[:return_url_event]!=nil)
            session[:return_to] = session[:return_url_event]
            session[:return_url_event] = nil
          end
    end
    
    def configure_lang
      @site = SiteSetting.first
      @lang = Language.find(@site[:site_language].to_i)
      set_locale(@lang[:language_prefix])
    end
    
    def authorize
      unless  @user = User.find_by_id(session[:user_id])
        session[:return_to] = request.url
        #session[:return_to] = session[:return_url_event]
        session[:user_id] = nil
        session[:user_email] = nil
        flash[:notice] = I18n.t 'application_controller.please_login_access_page'
        #redirect_to :controller => 'home' , :action => 'login' 
        respond_to do |format|
          format.html { redirect_to(:controller => 'home', :action => 'login/ret=yes') }
        end
      end
        if @user 
          if @user[:active]==0
              session[:user_id] = nil
              session[:user_email] = nil
              flash[:notice] = I18n.t 'application_controller.your_account_deactivated_by_admin'
              redirect_to :controller => 'home' 
           elsif @user[:set_pass]==0
              flash[:notice] = I18n.t 'application_controller.set_your_login_details_first'
              redirect_to :controller => 'home', :action => 'social_password'
           end     
        
        end
      
    end

  def event_authorize
    @event = Event.find(params[:id])
    @user = User.find(session[:user_id])
    eact = ''
    @has = Event.has_rights(@user, @event, eact)
    if @event[:user_id]!=@user[:id] && @has !=1
      flash[:notice] = I18n.t 'event_controllernot_access_page'
      redirect_to :controller => 'home'
    end
  end
  
=begin  
 def event_authorize
    @event = Event.find(params[:id])
    if @event[:user_id]!=session[:user_id]
      flash[:notice] = I18n.t 'event_controllernot_access_page'
      redirect_to :controller => 'home'
    end
  end  
=end  

  def generate_pdf(pur,event)
    @pur_pdf = pur
    @event = event
    @site = SiteSetting.find(:first)
    
    @order = OrderForm.find(:first, :conditions => ['event_id=?', @event[:id]])
    
    if @order
    else
      @order = OrderForm.new
    end
      
    color = 'eeeeee'
    
    barcode_value = @pur_pdf[:barcode_random]
    ### barcode 
    full_path = "public/data/barcode/"+"barcode_#{barcode_value}_#{@pur_pdf[:id].to_s}.png"
    barcode = Barby::Code128B.new(barcode_value)
    lang = I18n.locale.to_s
    if lang=='es' 
      bar_h = 240
      join_w = 350
    else
      bar_h = 270
      join_w = 430 
    end
    
    File.open(full_path, 'w') { |f| f.write barcode.to_png(:margin => 3, :xdim => 2, :height => 55) }
    
    ### qrcode
    qr = @pur_pdf[:barcode_random]
    
    qr = RQRCode::QRCode.new( barcode_value, :size => 4, :level => :h )
    qr_full_path = "public/data/qrcode/"+"qrcode_#{barcode_value}_#{@pur_pdf[:id].to_s}.png"
    png = qr.to_img                                             # returns an instance of ChunkyPNG
    png.resize(90, 90).save(qr_full_path)

    # File.open(qr_full_path, 'w') { |f| f.write barcode.to_png(:height => 100, :margin => 25, :xdim => 100) }
      
      barcode_image = "#{Rails.root}/"+full_path
      qr_image = "#{Rails.root}/"+qr_full_path
      
      #full_path = "/public/data/event/thumb/#{@event[:event_logo]}"
      
      if FileTest.exist?("#{Rails.root}"+"/public/data/thumb/event/#{@event[:event_logo]}")
        img_name = "#{Rails.root}/public/data/thumb/event/#{@event[:event_logo]}"
      elsif FileTest.exist?("#{Rails.root}"+"/public/data/orig/event/#{@event[:event_logo]}")
        img_name = "#{Rails.root}/public/data/orig/event/#{@event[:event_logo]}"
      else
        img_name = "#{Rails.root}/app/assets/images/no_img.png"
      end           
      image_check =  1
        
      title = @event[:event_title]
      
      start_time = @event[:event_start_date_time].strftime(@site[:date_time_format])     
      address = @event[:street_address]
      no = @pur_pdf[:id].to_s
      name = @pur_pdf[:first_name]+" "+@pur_pdf[:last_name]
      purtime = @pur_pdf[:created_at].strftime(@site[:date_time_format])
     
      if @pur_pdf[:ticket_id] > 0
        @ticket_detail = Ticket.find(@pur_pdf[:ticket_id]) 
        if @ticket_detail[:free]==1
            tic_name = @ticket_detail[:free_ticket_name]+' ('+(I18n.t "event.purchase.pdf_free")+')'
        elsif @ticket_detail[:paid]==1 
             tic_name = @ticket_detail[:paid_ticket_name]+' ('+(I18n.t "event.purchase.pdf_paid")+')'
        else  
             tic_name = @ticket_detail[:donation_ticket_name]+' ('+(I18n.t "event.purchase.pdf_donation")+')'
        end  
      else
         tic_name=I18n.t 'application_controller.multiple_tickets'
      end 
         tic_qty = @pur_pdf[:ticket_qty] 
                     
      
      logo_image = "#{Rails.root}/public/data/orig/other/"+@site[:site_logo]
      site_name = @site[:site_name]
      domain_name = APP_CONFIG['development']['site_url'].gsub('http://','').gsub('https://','').gsub('/','')
      
      pdf_header =  "#{Rails.root}/app/assets/images/pdf_header.png"
      if @order[:pdf_msg]!=nil && @order[:pdf_msg]!=''
          pdf_msg = @order[:pdf_msg]
      else
          pdf_msg = I18n.t "event.purchase.print"
      end
      
      
      Prawn::Document.generate('public/data/docs/'+@pur_pdf[:random_no]+'.pdf') do 
        
        image pdf_header,  :position => :center, :vposition => -45
         formatted_text_box([ { :text => (I18n.t "event.purchase.print_head"),
                        :size => 14,
                        :color => 'ffffff'
                         }], :at => [135,745])
                     
        formatted_text_box([ { :text => title,
                        :size => 18,
                        :color => '484848', :styles => [:bold]
                         }], :at => [0,610])                 
                         
       image img_name, :position => :right, :height => 110, :width => 110 , :vposition => 30
         
        data = [ [(I18n.t "event.purchase.date_time"), start_time], [(I18n.t "event.purchase.loc"), address], [(I18n.t "event.purchase.order_info"), (I18n.t "event.purchase.order")+' #'+no+(I18n.t "event.purchase.by")+name+' on '+purtime], [(I18n.t "event.purchase.tic_type"), tic_name], [(I18n.t "event.purchase.tic_qty"), tic_qty]]
               
        table(data, :column_widths => [120,420]) do
         
          cells.style(:border_color => 'ffffff', :border_width => 1, :padding => 15)
          cells.style do |c| 
            c.background_color = ((c.row) % 2).zero? ? 'bfbfbf' : 'f5f5f5' 
            
          end
        end
        
        text "\n"
       image barcode_image, :position => :right, :height => 60, :width => 290
       
       formatted_text_box([ { :text => barcode_value,
                        :size => 10,
                        :styles => [:bold, :italic]
                         }], :at => [310,bar_h])
                         
                         
       image qr_image, :position => :left, :height => 60, :width => 70 ,:vposition => 385
       
       formatted_text_box([ { :text => barcode_value,
                        :size => 10,
                        :styles => [:bold, :italic]
                         }], :at => [310,bar_h])
                         
      
       text pdf_msg 
      
      
      fill_color 'a9a7a7' 
      fill_rectangle [0, 57], 540, 1
       
      image logo_image,  :position => :left, :vposition => 690, :height => 26, :width => 152 
       
      formatted_text_box([ { :text => (I18n.t "event.purchase.do_you"),
                        :size => 16, :color => '000000'
                         }], :at => [360,47])
      formatted_text_box([ { :text => (I18n.t "event.purchase.join"),
                        :size => 12, :color => '010101'
                         }], :at => [join_w,27])
                                               
                                           
      formatted_text_box([ { :text => domain_name,
                        :size => 11,
                        :link => APP_CONFIG['development']['site_url'],
                        :color => '989898' }], :at => [430,13])                  
      end
    
  end
  
    
  def set_locale(lang)
    
   # if params[:locale] && params[:locale]!=''
    #    session[:locale] = params[:locale] 
    #end
   # I18n.locale = session[:locale] || I18n.default_locale
   I18n.locale = lang
    locale_path = "#{LOCALES_DIRECTORY}#{I18n.locale}.yml"
    
    unless I18n.load_path.include? locale_path
      I18n.load_path << locale_path
      I18n.backend.send(:init_translations)
    end
    
    rescue Exception => err
      logger.error err
      flash.now[:notice] = "#{I18n.locale} translation not available"
      I18n.load_path -= [locale_path]
      I18n.locale = session[:locale] = I18n.default_locale
  end

  private
  def render_error(status, exception)
    # Log the error
   
    respond_to do |format|
      @status = status
      @exception = exception
      format.html { render :template => "errors/error_#{status}", :layout => "/layouts/home", :status => status }
      format.all { render :nothing => true, :status => status } 
    end
  end
  
end