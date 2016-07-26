require 'rubygems'
require 'watir'

class MyTargetClient
  MYTARGET_URL = 'https://target.my.com/'

  def initialize
    @signed_in = false

    # Init Watir with Chrome webdriver
    @browser = Watir::Browser.new :chrome
  end

  def signed_in?
    @signed_in
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

          # Check if profile info loaded
          @browser.div(:class => 'profile2__name').wait_until_present
          if !@browser.div(:class => 'profile2__name').text.empty?
            @signed_in = true
            puts 'Logined as ' + @browser.div(:class => 'profile2__name').text
          else
            puts '*** Something went wrong during authorization'
          end
        end
      end
    else
      puts '*** Invalid user or password format'
    end
  end

  def create_application(app_name, app_url, adunit_name = 'Standart adunit name')
    if signed_in?
      # Create application and standart adunit
      @browser.goto(MYTARGET_URL + 'create_pad_groups')
      @browser.div(:class => 'pad-setting').wait_until_present
      @browser.text_field(:class => 'pad-setting__description__input').set(app_name)
      @browser.text_field(:class => 'pad-setting__url__input').set(app_url)
      @browser.div(:class => 'create-pad-groups-page__center-part-wrapper').wait_until_present
      @browser.text_field(:class => 'js-adv-block-description').set(adunit_name)
      @browser.div(:class => 'create-pad-groups-page__main-button').span(:class => 'main-button-new').click

      # Check if application created
      @browser.div(:class => 'pad-groups-stat-page__pad-groups-list-wrapper').wait_until_present
      if @browser.div(:class => 'pad-groups-stat-page__pad-groups-list-wrapper').a(:text => app_name).exists?
        puts '*** The app with name ' + app_name + ' has been created'
      else
        puts '*** Something went wrong during app creation'
      end
    else
      puts '*** User is not logined'
    end
  end
end


