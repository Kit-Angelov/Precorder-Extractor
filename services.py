"""
    Functions getting data
"""

import requests
from models.models import Channel, EPG
import config


def getChannels():
    response = requests.get(config.get_recorded_channels).json()
    channels_data = response.get('recorded-channels', None)
    channels = list()
    for elem in channels_data:
        newChannel = Channel.create(**elem)
        channels.append(newChannel)
    return channels


def getEpgList(channel="", search_text=""):
    if search_text is None:
        search_text = ""
    url = '{0}?channel={1}&string={2}'.format(config.search_epg, channel, search_text)
    response = requests.get(url).json()
    epgList_data = response.get('result', None)
    epgList = list()
    for elem in epgList_data:
        # print(elem)
        newEpg = EPG.create(**elem)
        epgList.append(newEpg)
    return epgList