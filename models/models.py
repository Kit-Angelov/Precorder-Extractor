"""
    class-based model of channel and EPG
"""

import config


class Channel:

    address = ''
    recorderId = ''
    recorderIp = ''
    recorderPort = ''
    name = ''

    @classmethod
    def create(cls, **kwargs):

        newChannel = cls()
        newChannel.address = kwargs.get('address', newChannel.address)
        newChannel.recorderId = kwargs.get('recorderId', newChannel.recorderId)
        newChannel.recorderIp = kwargs.get('recorderIp', newChannel.recorderIp)
        newChannel.recorderPort = kwargs.get('recorderPort', newChannel.recorderPort)
        newChannel.name = kwargs.get('name', newChannel.name)

        return newChannel


class EPG:
    title = ''
    date = ''
    startTime = ''
    endTime = ''
    eventId = ''
    duration = ''
    recorder = ''
    description = ''
    id = ''
    image = ''
    chName = ''


    @classmethod
    def create(cls, **kwargs):
        newEPG = cls()
        newEPG.title = kwargs.get('title', newEPG.title)
        newEPG.date = kwargs.get('date', newEPG.date)
        newEPG.startTime = kwargs.get('startTime', newEPG.startTime)
        newEPG.endTime = kwargs.get('endTime', newEPG.endTime)
        newEPG.eventId = kwargs.get('duration', newEPG.duration)
        newEPG.recorder = kwargs.get('recorder', newEPG.recorder)
        newEPG.description = kwargs.get('description', newEPG.description)
        newEPG.id = kwargs.get('id', newEPG.id)
        newEPG.chName = kwargs.get('chName', newEPG.chName)
        newEPG.image = config.imgDict.get(newEPG.chName, None)

        return newEPG
