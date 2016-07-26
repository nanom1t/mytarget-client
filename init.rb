require_relative 'app/mytarget_client'

MYTARGET_LOGIN = 'ruby_rails@mail.ru'
MYTARGET_PASSWORD = '1qazxsw2!@$$'
APP_NAME = 'Angry Birds'
APP_URL = 'https://itunes.apple.com/en/app/angry-birds/id343200656?mt=8'

mytarget_client = MyTargetClient.new
mytarget_client.authorize(MYTARGET_LOGIN, MYTARGET_PASSWORD)
mytarget_client.create_application(APP_NAME, APP_URL, 'Standart ad unit')