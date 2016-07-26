require_relative 'app/mytarget_client'

MYTARGET_LOGIN = 'ruby_rails@mail.ru'
MYTARGET_PASSWORD = '1qazxsw2!@$$'

mytarget_client = MyTargetClient.new
mytarget_client.authorize(MYTARGET_LOGIN, MYTARGET_PASSWORD)