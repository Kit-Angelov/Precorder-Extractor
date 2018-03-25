import os
from configparser import ConfigParser

host = '82.240.161.221'
port = '1780'


def setConfig(section, key, value):
    config = ConfigParser()
    config.read('config.ini')
    config[section][key] = value
    with open('config.ini', 'w') as conf:
        config.write(conf)

def getSavePath():
    config = ConfigParser()
    config.read('config.ini')
    try:
        savePath = config['SAVE']['path']
        if os.path.exists(savePath) is False:
            savePath = None
    except:
        savePath = None
    return savePath

def getStorePath():
    config = ConfigParser()
    config.read('config.ini')
    try:
        savePath = config['STORE']['path']
        if os.path.exists(savePath) is False:
            savePath = None
    except:
        savePath = None
    return savePath

def getHost():
    config = ConfigParser()
    config.read('config.ini')
    try:
        return config['URL']['host']
    except:
        return host

def getPort():
    config = ConfigParser()
    config.read('config.ini')
    try:
        config = ConfigParser()
        config.read('config.ini')
        return config['URL']['port']
    except:
        return port

def getDataUrl():
    return 'http://{0}/precorderweb/api/'.format(getHost())

def getMediaUrl():
    return 'http://{0}:{1}/'.format(getHost(), getPort())

def getRecordedChannels():
    return '{0}get-recorded-channels/'.format(getDataUrl())

def getSerachEpg():
    return '{0}epg-search/'.format(getDataUrl())

base_dir = os.path.dirname(os.path.abspath(__name__))

media = os.path.join(base_dir, 'media')

# temp_media = os.path.join(media, 'temp_media')
temp_media = "precorder_media"

imgDict = {
    "France 4": "../media/chLogo/France4.gif",
    "RTL9": "../media/chLogo/RTL9.png",
    "F3 Côte d'Azur": "../media/chLogo/France3_cote_azur.png",
    "France 3": "../media/chLogo/France3_cote_azur.png",
}

lastFramePath = "../media/lastFrame.png"

bufferValue = 1000

updateStep = 0.4

windowWidth = 1295
windowHeight = 690

# http://82.240.161.221:1780/225.1.1.27:12345.record?from=1519049100&to=1519049700
# http://82.240.161.221/precorderweb/api/epg-search/?channel=225.1.1.14:12345
# 77.140.204.69