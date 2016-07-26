require 'rubygems'
require 'watir'

class MyTargetClient
  MYTARGET_URL = 'https://target.my.com/'

  def initialize
    # Init Watir with Chrome webdriver
    @browser = Watir::Browser.new :chrome
  end

  def authorize(login, password)
    @login = login
    @password = password

    if !@login.empty? and !@password.empty?
      # Go to MyTarget and try to log in via Mail.ru
      @browser.goto(MYTARGET_URL)
      @browser.span(:class =>'js-head-log-in').wait_until_present
      @browser.span(:class =>'js-head-log-in').click
      @browser.span(:class =>'auth-popup__social-icon_mail').wait_until_present
      @browser.span(:class =>'auth-popup__social-icon_mail').click

      Watir::Wait.until { @browser.windows.size == 2 }
      @browser.window(:title => 'OAuth').use do
        # Fill in auth form with credentials
        @browser.div(:id => 'auth').wait_until_present
        @browser.text_field(:name => 'Login').set(@login.split('@')[0])
        @browser.text_field(:name => 'Password').set(@password)
        @browser.button(:class => 'btn', :data_name => 'user-login').click

        # Check if any errors duting authorization
        if @browser.div(:class, 'b-form__error').exists? and !@browser.div(:class, 'b-form__error').text.empty?
          puts '*** Authorization error: ' + @browser.div(:class, 'b-form__error').text
        else
          # Choose an account to login
          @browser.div(:class => 'accounts').wait_until_present
          @browser.div(:class => 'accounts__item', :data_value => @login).click
          Watir::Wait.until { @browser.windows.size == 1 }
          @browser.windows.first.use
        end
      end
    end
  end
end


