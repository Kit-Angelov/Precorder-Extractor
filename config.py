import os
from configparser import ConfigParser

def getHost():
    config = ConfigParser()
    config.read('config.ini')
    return config['URL']['url']

def getPort():
    config = ConfigParser()
    config.read('config.ini')
    return config['PORT']['port']

def getDataUrl():
    return '{0}/precorderweb/api/'.format(getHost())

def getMediaUrl():
    return '{0}:{1}/'.format(getHost(), getPort())

host = 'http://82.240.161.221/precorderweb/api/'
mediahost = 'http://82.240.161.221:1780/'

get_recorded_channels = host + 'get-recorded-channels/'
search_epg = host + 'epg-search/'

base_dir = os.path.dirname(os.path.abspath(__name__))

media = os.path.join(base_dir, 'media')

# temp_media = os.path.join(media, 'temp_media')
temp_media = "precorder_media"

imgDict = {
    "France 4": "../media/chLogo/France4.gif",
    "RTL9": "../media/chLogo/RTL9.png"
}

lastFramePath = "../media/lastFrame.png"

bufferValue = 1000

updateStep = 0.4

windowWidth = 1295
windowHeight = 690

# http://82.240.161.221:1780/225.1.1.27:12345.record?from=1519049100&to=1519049700
# http://82.240.161.221/precorderweb/api/epg-search/?channel=225.1.1.14:12345
# 77.140.204.69