require "spec_helper"

describe "MyTarget" do
  subject { page }

  WATIR_DEFAULT_TIMEOUT = 90
  MYTARGET_URL = 'https://target.my.com/'
  MYTARGET_LOGIN = 'ruby_rails@mail.ru'
  MYTARGET_PASSWORD = '1qazxsw2!@$$'
  APP_NAME = 'Angry Birds Test 2'
  APP_URL = 'https://itunes.apple.com/en/app/angry-birds/id343200656?mt=8'
  ADUNIT_STANDART_NAME = 'Standart adunit name'
  ADUNIT_FULLSCREEN_NAME = 'Fullscreen adunit name'

  describe "Authorization" do
    it "should has login button" do
      goto MYTARGET_URL
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

      it "should has account choose option" do
        expect(div(:class => 'accounts')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
        expect(div(:class => 'accounts__item', :data_value => MYTARGET_LOGIN)).to be_present.within(WATIR_DEFAULT_TIMEOUT)
        div(:class => 'accounts__item', :data_value => MYTARGET_LOGIN).click
      end

      it "shoud close Mail.ru oauth window after choosing account" do
        Watir::Wait.until { windows.size == 1 }
        windows.first.use
      end

      it "shoud has profile info loaded" do
        expect(div(:class => 'profile2__name')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
        expect(div(:class => 'profile2__name').text).to_not be_empty
      end
    end
  end

  describe "App creation page" do
    it "should has description form" do
      goto(MYTARGET_URL + 'create_pad_groups')
      expect(div(:class => 'pad-setting')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(text_field(:class => 'pad-setting__description__input')).to be_present
      expect(text_field(:class => 'pad-setting__url__input')).to be_present

      text_field(:class => 'pad-setting__description__input').set(APP_NAME)
      text_field(:class => 'pad-setting__url__input').set(APP_URL)
    end

    it "should load app url info" do
      expect(div(:class => 'create-pad-groups-page__center-part-wrapper')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(text_field(:class => 'js-adv-block-description')).to be_present
      expect(div(:class => 'create-pad-groups-page__main-button')).to be_present

      text_field(:class => 'js-adv-block-description').set(ADUNIT_STANDART_NAME)
      div(:class => 'create-pad-groups-page__main-button').span(:class => 'main-button-new').click
    end

    it "should created an application" do
      expect(div(:class => 'pad-groups-stat-page__pad-groups-list-wrapper')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(div(:class => 'pad-groups-stat-page__pad-groups-list-wrapper').a(:text => APP_NAME)).to be_present

      div(:class => 'pad-groups-stat-page__pad-groups-list-wrapper').a(:text => APP_NAME).click
    end

    it "should create standart ad unit" do
      expect(div(:class => 'pads-stat-page__pads-list-wrapper')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(a(:class => 'pads-list__link', :text => ADUNIT_STANDART_NAME)).to be_present

      a(:class => 'pads-list__link', :text => ADUNIT_STANDART_NAME).click
    end

    it "should have slot_id for standart ad unit" do
      expect(div(:class => 'pad-stat-page__partner-instruction')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(div(:class => 'pad-stat-page__partner-instruction').p(:class => 'js-slot-id').text).to_not be_empty
    end
  end

  describe "Fullscreen adunit creation" do
    it "shoud have link to app adunits" do
      expect(a(:class => 'bread-crumbs__item__link', :text => APP_NAME)).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      a(:class => 'bread-crumbs__item__link', :text => APP_NAME).click
    end

    it "should has create placement button" do
      expect(a(:class => 'pads-control-panel__button_create')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      a(:class => 'pads-control-panel__button_create').click
    end

    it "should load new placement page" do
      expect(div(:class => 'create-pad-page__block-form-wrap')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(text_field(:class => 'js-adv-block-description')).to be_present
      expect(div(:class => 'format-item__image_fullscreen')).to be_present
      expect(span(:class => 'create-pad-page__save-button')).to be_present

      text_field(:class => 'js-adv-block-description').set(ADUNIT_FULLSCREEN_NAME)
      div(:class => 'format-item__image_fullscreen').click
      span(:class => 'create-pad-page__save-button').click
    end

    it "shoud create new adunit" do
      expect(div(:class => 'pads-stat-page__pads-list-wrapper')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(a(:class => 'pads-list__link', :text => ADUNIT_FULLSCREEN_NAME)).to be_present

      a(:class => 'pads-list__link', :text => ADUNIT_FULLSCREEN_NAME).click
    end

    it "should have slot_id for fullscreen ad unit" do
      expect(div(:class => 'pad-stat-page__partner-instruction')).to be_present.within(WATIR_DEFAULT_TIMEOUT)
      expect(div(:class => 'pad-stat-page__partner-instruction').p(:class => 'js-slot-id').text).to_not be_empty
    end
  end
end