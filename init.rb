require_relative 'app/mytarget_client'
require 'pp'

MYTARGET_LOGIN = 'ruby_demo@mail.ru' #'ruby_rails@mail.ru'
MYTARGET_PASSWORD = '1qazxsw2!@$$'
APP_NAME = 'Angry Birds'
APP_URL = 'https://itunes.apple.com/en/app/angry-birds/id343200656?mt=8'

mytarget_client = MyTargetClient.new
mytarget_client.authorize(MYTARGET_LOGIN, MYTARGET_PASSWORD)
app_info = mytarget_client.create_application(APP_NAME, APP_URL, 'Standart adunit name')
adunit_info = mytarget_client.create_adunit(app_info[:app_id], 'Fullscreen adunit name', MyTargetClient::ADUNIT_TYPE_FULLSCREEN)
app_info[:slots].push({ :slot_id => adunit_info[:slot_id] })

pp app_info