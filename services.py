"""
    Functions getting data
"""

import requests
from models.models import Channel, EPG
import config


def getChannels(connectLabel):
    print('URL', config.getRecordedChannels())
    try:
        response = requests.get(config.getRecordedChannels()).json()
        channels_data = response.get('recorded-channels', None)
    except:
        channels_data = []
    channels = list()
    if len(channels_data) is not 0:
        connectLabel.hide()
        for elem in channels_data:
            newChannel = Channel.create(**elem)
            channels.append(newChannel)
    else:
        connectLabel.show()
        emptyChannel = Channel.create()
        channels.append(emptyChannel)
    return channels


def getEpgList(channel="", search_text=""):
    if search_text is None:
        search_text = ""
    url = '{0}?channel={1}&string={2}'.format(config.getSerachEpg(), channel, search_text)
    try:
        response = requests.get(url).json()
        epgList_data = response.get('result', None)
    except:
        epgList_data = []
    epgList = list()
    for elem in epgList_data:
        newEpg = EPG.create(**elem)
        epgList.append(newEpg)
    return epgList