class Event < ActiveRecord::Base
   belongs_to :user
   has_many :attendees
   has_many :event_repeats
   has_many :event_themes
   has_many :tickets
   has_many :order_forms
   has_many :event_updates
   has_many :waitlists
   has_many :waiting_lists
   has_many :promotional_codes
   has_many :questions
   
   attr_accessible   :user_id, :event_title, :vanue_name, :street_address, :online_event_option, :show_on_map, :event_start_date_time, 
                     :event_end_date_time, :display_start_time, :display_end_time, :event_repeat, :event_repeat_text, :event_logo, :event_detail, 
                     :organizer_host, :host_description, :add_social_link, :add_facebook, :facebook_link, :add_twitter, :twitter_link, 
                     :keep_private, :share_on_social, :invite_only, :password_protect, :password_value, :category, :subcategory, 
                     :remaining_tickets, :event_url_link, :event_capacity, :event_pass_fees, :event_time_zone, :display_time_zone, :organizer_id, 
                     :display_attendee, :attendee_id, :allow_facebook, :active, :event_type, :language_id, :google_code, :cancel, :cancel_date_time,
                     :page_visits, :feature, :city
  
  
  

  
  validates_uniqueness_of :event_url_link, :allow_blank => true
  
 EVENT_REPEATS = [
  # Displayed stored in db
    [ "Never" , 0 ],
    [ "Daily" , 1 ],
    [ "Weekly" , 2 ],
    [ "Monthly" , 3 ],
    [ "Other (be specific)" , 4 ]
  ]
  
 
 DAYS_NUMBER = [
    [1,1],      [2,2],      [3,3],      [4,4],      [5,5],      [6,6],      [7,7],      [8,8],      [9,9],      [10,10],    [11,11],    
    [12,12],    [13,13],    [14,14],    [15,15],    [16,16],    [17,17],    [18,18],    [19,19],    [20,20],    [21,21],    [22,22],    
    [23,23],    [24,24],    [25,25],    [26,26],    [27,27],    [28,28],    [29,29],    [30,30],    [31,31] ]
    
 
 WEEK_NUMBER = [    [1,1],      [2,2],      [3,3],      [4,4],      [5,5],      [6,6],      [7,7],      [8,8],      [9,9],      [10,10],    [11,11],    
    [12,12] ]
    
    
 MONTH_REPEAT_NUM = [    ["First",1],      ["Second",2],      ["Third",3],      ["Fourth",4],      ["Fifth",5],    ["Last",6] ]    
 
 
 MONTH_REPEAT_DAY = [    ["Monday",1],      ["Tuesday",2],      ["Wednesday",3],      ["Thursday",4],      ["Friday",5],    ["Saturday",6],    ["Sunday",7] ]  
 
 

   validates_inclusion_of :event_repeat, :in => EVENT_REPEATS.map {|disp, value| value}
  
  
#### event listing starts ######
 ##### all events
 def self.find_all_events(id)
      @events = self.find(:all, :conditions =>  ["user_id = ? ", id] )
      @events
 end
 

 def self.find_featured_events
     @events = self.find(:all, :conditions =>  ["active = ? AND event_end_date_time >= ? AND cancel = ? AND keep_private=0 AND feature=1", 1, Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
     @events
 end
 ##### live events
 def self.find_live_events(id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND active = ? AND event_end_date_time >= ? AND cancel = ?", id, 1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
      @events
 end
 
 def self.find_live_org_session_events(user_id, org_id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND organizer_id=? AND active = ? AND event_end_date_time >= ? AND cancel = ?", user_id, org_id,  1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
      @events
 end
 
 def self.find_live_org_events(id)
      @events = self.find(:all, :conditions =>  ["organizer_id = ? AND active = ? AND event_end_date_time >= ? AND cancel = ?", id, 1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
      @events
 end
 
 
 def self.find_live_event_with_city(city)
    @events = self.find(:all, :conditions =>  ["(vanue_name like ? or street_address like ?) AND active = ? AND event_end_date_time >= ? AND cancel = ? AND keep_private=0", "%#{city}%", "%#{city}%", 1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
    @events
 end
 
 def self.find_live_event_wo_city
    @events = self.find(:all, :conditions =>  ["active = ? AND event_end_date_time >= ? AND cancel = ? AND keep_private=0", 1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
    @events
 end
 
  
 
 ##### draft events
 def self.find_draft_events(id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND active = ? AND cancel = ?", id, 0, 0] )
      @events
 end
 
 def self.find_draft_org_session_events(user_id, org_id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND organizer_id = ? AND active = ? AND cancel = ?", user_id, org_id, 0, 0] )
      @events
 end
 
  ##### cancelled events
 def self.find_cancel_events(id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND cancel = ?", id, 1] )
      @events
 end
 
 def self.find_cancel_org_session_events(user_id, org_id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND organizer_id =? AND cancel = ?", user_id, org_id, 1] )
      @events
 end
 
 
 #####  passout events
 def self.find_pass_events(id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND active = ? AND event_end_date_time < ? AND cancel = ?", id, 1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
      @events
 end
 
 def self.find_pass_org_session_events(user_id, org_id)
      @events = self.find(:all, :conditions =>  ["user_id = ? AND organizer_id=? AND active = ? AND event_end_date_time < ? AND cancel = ?", user_id, org_id, 1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
      @events
 end


 def self.find_pass_org_events(id)
      @events = self.find(:all, :conditions =>  ["organizer_id = ? AND active = ? AND event_end_date_time < ? AND cancel = ?", id, 1,  Time.now.strftime('%Y-%m-%d %H:%M:%S'), 0] )
      @events
 end
#### event listing end ######
 
  def self.saveimage(upload)
   num1 = 'logo_'+SecureRandom.hex(5)
   fname = upload['datafile'].original_filename.gsub(' ','')
    name = num1+'_'+fname
    directory = "public/data/orig/event"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    
    @content = Cloudinary::Uploader.upload(directory+'/'+name,:public_id => "sample_id",
                            :crop => :thumb, :width => 175, :height => 175)
    directory = "public/data/thumb/event"
    # create the file path
    path = File.join(directory, name)
   #File.open(path, "wb") { |f| f.write(@content['eager'][0]['url']) }
   require 'open-uri'
    open(path, 'wb') do |file|
      file << open(@content['url']).read
    end
   Cloudinary::Uploader.destroy(@content['public_id'])
    name
  end
  
   ### all admin side function 
   def self.find_all_events_admin(id)
      @events = self.find(:all, :conditions =>  ["user_id >= ? ", id] )
      @events
   end
=begin
  [{"url":"http://res.cloudinary.com/anita-rockers/image/upload/c_thumb,e_sepia,g_face,h_200,r_20,w_200/v1392111975/sample_id.jpg","secure_url":"https://res.cloudinary.com/anita-rockers/image/upload/c_thumb,e_sepia,g_face,h_200,r_20,w_200/v1392111975/sample_id.jpg"}]
=end  

def self.has_rights(user, event, act)
      @user = user
      @eve = event
      @has = 0
        
        if @user[:ref_id]!=nil && @user[:ref_id]!='' && @user[:ref_id] > 0 
            @permission = Permission.find(:first, :conditions => ['user_id=? AND admin_id=?', @user[:id], @user[:ref_id]])
            if @permission
                if @permission[:event]!=nil && @permission[:action]!=nil
                    @per_events = @permission[:event].split(',')
                    @per_act = @permission[:action].split(',')
                    
                    if(@permission[:event]=='all' || @per_events.include?(@eve[:id].to_s))
                      if (act=='' || act==nil)
                          @has = 1  
                      elsif (@permission[:action]=='all' || @per_act.include?(act)) 
                          @has = 1
                      end
                    else
                        @has = 3
                    end  
                else
                  @has = 0  
                end
            else
              @has = 0  
            end
        else
            @has = 1  
        end
      
      return @has
   end


def self.has_email_rights(user, event, act)
      @user = user
      @eve = event
      @has = 0
        
        if @user[:ref_id]!=nil && @user[:ref_id]!='' && @user[:ref_id] > 0 
            @permission = Permission.find(:first, :conditions => ['user_id=? AND admin_id=?', @user[:id], @user[:ref_id]])
            if @permission
                if @permission[:event]!=nil && @permission[:action]!=nil
                    @per_events = @permission[:event].split(',')
                    @per_act = @permission[:email].split(',')
                    
                    if(@permission[:event]=='all' || @per_events.include?(@eve[:id].to_s))
                      if (act=='' || act==nil)
                          @has = 1  
                      elsif (@permission[:email]=='all' || @per_act.include?(act)) 
                          @has = 1
                      end
                    else
                        @has = 3
                    end  
                else
                  @has = 0  
                end
            else
              @has = 0  
            end
        else
            @has = 1  
        end
      
      return @has
   end

  
end 