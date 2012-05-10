require 'rubygems'
require 'mechanize'

namespace :dropbox do
  
  task :register do
    
    password = 'Asdf1234'
    email_address = nil
    first_name = nil
    last_name = nil
    
    agent = Mechanize.new
    
    # Choose a random agent each time.
    user_agent_list = [];
    Mechanize::AGENT_ALIASES.map do | key, value |
      if key != 'Mechanize'
        user_agent_list.push( key )
      end
    end
    
    agent.user_agent_alias = user_agent_list[ rand( user_agent_list.size ) ]
    
    # Fetch the email address
    # agent.get( 'http://10minutemail.com/10MinuteMail/index.html' ) do | email_page |
    #   email_form = email_page.form_with( :id => "addyForm" )
    #   email_address = email_form.field_with( :id => "addyForm:addressSelect" ).value
    # end
    
    agent.get( 'http://www.guerrillamail.com' ) do | email_page |
      email_address = email_page.search( "#email" ).map( &:text ).first + "@sharklasers.com"
    end
    
    # Fetch a first name and last name
    agent.get( 'http://www.behindthename.com/random/random.php?number=1&gender=both&surname=&randomsurname=yes&all=yes' ) do | name_page |
      first_name = name_page.links_with( :class => "plain" )[ 0 ].text()
      last_name = name_page.links_with( :class => "plain" )[ 1 ].text()
    end
    
    puts first_name + " " + last_name
    puts email_address

    agent.get( 'https://www.dropbox.com/referrals/NTQwNzA1ODE5?src=global9' ) do | signup_page |
      
      # Submit the login form
      signup_page.form_with( :action => "" ) do | form |
        form.fname = first_name
        form.lname = last_name
        form.email = email_address
        form.password = password
        form.checkbox_with( :id => 'tos_agree' ).check
      end.click_button
    
    end

    puts "Registered."
  end
end