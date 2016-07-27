require "spec_helper"

describe "MyTarget" do
  subject { page }

  WATIR_DEFAULT_TIMEOUT = 90
  MYTARGET_LOGIN = 'ruby_rails@mail.ru'
  MYTARGET_PASSWORD = '1qazxsw2!@$$'
  APP_NAME = 'Angry Birds'
  APP_URL = 'https://itunes.apple.com/en/app/angry-birds/id343200656?mt=8'

  describe "Authorization" do
    it "should has login button" do
      goto "https://target.my.com/"
      expect(span(:class =>'js-head-log-in')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      span(:class => 'js-head-log-in').click
    end

    describe "popup" do
      it "should has auth popup window" do
        expect(div(:class => 'auth-popup')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      end

      it "shoud has ability to login via Mail.ru" do
        expect(span(:class =>'auth-popup__social-icon_mail')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
        span(:class =>'auth-popup__social-icon_mail').click
      end

      it "shoud create Mail.ru oauth window" do
        Watir::Wait.until { windows.size == 2 }
        expect(windows.last.title).to eq('OAuth')
        windows.last.use
      end

      it "shoud create Mail.ru login form" do
        expect(div(:id => 'auth')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
        expect(text_field(:name => 'Login')).to be_present
        expect(text_field(:name => 'Password')).to be_present
        expect(button(:class => 'btn', :data_name => 'user-login')).to be_present

        text_field(:name => 'Login').set(MYTARGET_LOGIN.split('@')[0])
        text_field(:name => 'Password').set(MYTARGET_PASSWORD)
        button(:class => 'btn', :data_name => 'user-login').click
      end

      it "should not be any errors during authorization" do
        expect(div(:class, 'b-form__error')).to_not be_present.within(10)
      end

    end
  end
end