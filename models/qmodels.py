"""
    Qt-based model Channel and EPG
"""

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty
from PyQt5.QtQml import QQmlListProperty
from services import getChannels, getEpgList


class Channel(QObject):
    channelAddress = pyqtSignal()
    channelRecorderId = pyqtSignal()
    channelRecorderIp = pyqtSignal()
    channelRecorderPort = pyqtSignal()
    channelName = pyqtSignal()

    def __init__(self, channel, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._channel_address = str(channel.address)
        self._channel_recorderId = str(channel.recorderId)
        self._channel_recorderIp = str(channel.recorderIp)
        self._channel_recorderPort = str(channel.recorderPort)
        self._channel_name = str(channel.name)

    @pyqtProperty('QString', notify=channelAddress)
    def address(self):
        return self._channel_address

    @pyqtProperty('QString', notify=channelRecorderId)
    def recorderId(self):
        return self._channel_recorderId

    @pyqtProperty('QString', notify=channelRecorderIp)
    def recorderIp(self):
        return self._channel_recorderIp

    @pyqtProperty('QString', notify=channelRecorderPort)
    def recorderPort(self):
        return self._channel_recorderPort

    @pyqtProperty('QString', notify=channelName)
    def name(self):
        return self._channel_name


class ListChannels(QObject):
    listChannels = pyqtSignal()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._channels = []
        self.setChannel()

    def setChannel(self):
        channels = getChannels()
        for channel in channels:
            self._channels.append(Channel(channel))

    @pyqtProperty(QQmlListProperty, notify=listChannels)
    def channels(self):
        return QQmlListProperty(Channel, self, self._channels)


class EPG(QObject):
    epgTitle = pyqtSignal()
    epgDate = pyqtSignal()
    epgStartTime = pyqtSignal()
    epgEndTime = pyqtSignal()
    epgEventId = pyqtSignal()
    epgDuration = pyqtSignal()
    epgRecorder = pyqtSignal()
    epgDescription = pyqtSignal()
    epgId = pyqtSignal()
    epgImage = pyqtSignal()
    epgChName = pyqtSignal()

    def __init__(self, epg, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._epg_title = str(epg.title)
        self._epg_date = str(epg.date)
        self._epg_startTime = str(epg.startTime)
        self._epg_endTime = str(epg.endTime)
        self._epg_eventId = str(epg.eventId)
        self._epg_duration = str(epg.duration)
        self._epg_recorder = str(epg.recorder)
        self._epg_description = str(epg.description)
        self._epg_id = str(epg.id)
        self._epg_image = str(epg.image)
        self._epg_chName = str(epg.chName)

    @pyqtProperty('QString', notify=epgTitle)
    def title(self):
        return self._epg_title

    @pyqtProperty('QString', notify=epgId)
    def id(self):
        return self._epg_id

    @pyqtProperty('QString', notify=epgDate)
    def date(self):
        return self._epg_date

    @pyqtProperty('QString', notify=epgStartTime)
    def startTime(self):
        return self._epg_startTime

    @pyqtProperty('QString', notify=epgEndTime)
    def endTime(self):
        return self._epg_endTime

    @pyqtProperty('QString', notify=epgRecorder)
    def recorder(self):
        return self._epg_recorder

    @pyqtProperty('QString', notify=epgImage)
    def image(self):
        return self._epg_image

    @pyqtProperty('QString', notify=epgDescription)
    def description(self):
        return self._epg_description


class ListEpg(QObject):
    listEpg = pyqtSignal()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._epglist = []
        self.address = None
        self.query = None

    def setEpg(self, address=None, query=None):
        self.address = address
        self._epglist = []
        epg_list = getEpgList(channel=address, search_text=query)
        for epg in epg_list:
            self._epglist.append(EPG(epg))

    @pyqtProperty(QQmlListProperty, notify=listEpg)
    def epg_list(self):
        return QQmlListProperty(EPG, self, self._epglist)

    chooseChannelSingal = pyqtSignal(str, arguments=['chooseChannel'])

    @pyqtSlot(str)
    def chooseChannel(self, address):
        self.address = address
        self.setEpg(self.address, query=self.query)
        self.listEpg.emit()

    searchSignal = pyqtSignal(str, arguments=['search'])

    @pyqtSlot(str)
    def search(self, query):
        self.query = query
        if self.address is not None:
            self.setEpg(self.address, query=self.query)
            self.listEpg.emit()


class SelectedEPG(QObject):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._title = None
        self._description = None
        self._date = None
        self._start_time = None
        self._end_time = None

    epgTitleSignal = pyqtSignal()
    epgDeskSignal = pyqtSignal()
    epgDateSignal = pyqtSignal()
    epgStartTimeSignal = pyqtSignal()
    epgEndTimeSignal = pyqtSignal()

    @pyqtProperty('QString', notify=epgTitleSignal)
    def epgTitle(self):
        return self._title

    @pyqtProperty('QString', notify=epgDeskSignal)
    def epgDesk(self):
        return self._description

    @pyqtProperty('QString', notify=epgDateSignal)
    def epgDate(self):
        print('date', self._date)
        return self._date

    @pyqtProperty('QString', notify=epgStartTimeSignal)
    def epgStartTime(self):
        return self._start_time

    @pyqtProperty('QString', notify=epgEndTimeSignal)
    def epgEndTime(self):
        return self._end_time

    def setSelectedEPG(self, epg):
        self._title = epg._epg_title
        self._description = epg._epg_description
        self._date = epg._epg_date
        self._start_time = epg._epg_startTime
        self._end_time = epg._epg_endTime
        self.epgTitleSignal.emit()
        self.epgDeskSignal.emit()
        self.epgDateSignal.emit()
        self.epgStartTimeSignal.emit()
        self.epgEndTimeSignal.emit()


class SegmentPosition(QObject):
    def __init__(self, startTime, endTime, startTimestamp, endTimestamp, recorder, title, id, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._startTime = startTime
        self._endTime = endTime
        self._startTimestamp = startTimestamp
        self._endTimestamp = endTimestamp
        self._recorder = recorder
        self._title = title
        self._id = id
        self._stateDL = 0

    startTimeSignal = pyqtSignal()
    endTimeSignal = pyqtSignal()
    startTimestampSignal = pyqtSignal()
    endTimestampSignal = pyqtSignal()
    recorderSignal = pyqtSignal()
    titleSignal = pyqtSignal()
    idSignal = pyqtSignal()
    stateDLSignal = pyqtSignal()

    @pyqtProperty('QString', notify=startTimeSignal)
    def startTime(self):
        return self._startTime

    @pyqtProperty('QString', notify=endTimeSignal)
    def endTime(self):
        return self._endTime

    @pyqtProperty('QString', notify=startTimestampSignal)
    def startTimestamp(self):
        return self._startTimestamp

    @pyqtProperty('QString', notify=endTimestampSignal)
    def endTimestamp(self):
        return self._endTimestamp

    @pyqtProperty('QString', notify=recorderSignal)
    def recorder(self):
        return self._recorder

    @pyqtProperty('QString', notify=titleSignal)
    def title(self):
        return self._title

    @pyqtProperty(int, notify=idSignal)
    def id(self):
        return self._id

    @pyqtProperty(int, notify=stateDLSignal)
    def stateDL(self):
        return self._stateDL

    def setStartTime(self, startTime, startTimestamp):
        self._startTime = startTime
        self._startTimestamp = startTimestamp

    def setEndTime(self, endTime, endTimestamp):
        self._endTime = endTime
        self._endTimestamp = endTimestamp

    def setRecorder(self, recorder):
        self._recorder = recorder

    def setTitle(self, title):
        self._title = title

    def setId(self, id):
        self._id = id

    def changeState(self, state):
        self._stateDL = int(state)
        self.stateDLSignal.emit()


class ListSegmentPostiton(QObject):
    listSegmentPosition = pyqtSignal()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._listSegment = []
        self.setSegment()

    @pyqtProperty(QQmlListProperty, notify=listSegmentPosition)
    def segment_list(self):
        return QQmlListProperty(SegmentPosition, self, self._listSegment)

    def setSegment(self):
        for item in range(3):
            self._listSegment.append(SegmentPosition('', '', 0, 0, None, None, None))

    def setStartSegment(self, startTime, startTimestamp, recorder, title, id):
        for i in range(len(self._listSegment)):
            if i == 0 and self._listSegment[i].startTime == '' and self._listSegment[i].startTimestamp == 0:
                self._listSegment[i].setStartTime(startTime, startTimestamp)
                self._listSegment[i].setRecorder(recorder)
                self._listSegment[i].setTitle(title)
                self._listSegment[i].setId(id)
                self.listSegmentPosition.emit()
                return 0
            elif self._listSegment[i].startTime == '' and self._listSegment[i].startTimestamp == 0 and self._listSegment[i-1].endTimestamp != 0:
                self._listSegment[i].setStartTime(startTime, startTimestamp)
                self._listSegment[i].setRecorder(recorder)
                self._listSegment[i].setTitle(title)
                self._listSegment[i].setId(id)
                self.listSegmentPosition.emit()
                return 0
            elif self._listSegment[i-1].startTimestamp != 0 and self._listSegment[i-1].endTimestamp == 0:
                return 0
        self._listSegment.append(SegmentPosition(startTime, '', startTimestamp, 0, recorder, title, id))
        self.listSegmentPosition.emit()

    def setEndSegment(self, endTime, endTimestamp, id):
        for item in self._listSegment:
            if item.endTime == '' and item.endTimestamp == 0 and item.startTime != '' and item.startTimestamp != 0:
                if endTimestamp > item.startTimestamp and id == item.id:
                    item.setEndTime(endTime, endTimestamp)
                    self.listSegmentPosition.emit()
                    return 0

    def update(self):
        self.listSegmentPosition.emit()

    def deleteSegment(self, index):
        try:
            deletedItem = self._listSegment.pop(index)
            if len(self._listSegment) < 3:
                self._listSegment.append(SegmentPosition('', '', 0, 0, None, None, None))
        except:
            pass
        self.listSegmentPosition.emit()

    def deleteAllSegment(self):
        self._listSegment = []
        self.setSegment()
        self.listSegmentPosition.emit()


class Logs(QObject):
    logSignal = pyqtSignal()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._logsStr = ''

    @pyqtProperty('QString', notify=logSignal)
    def logs(self):
        return self._logsStr

    def updateLogs(self):
        try:
            with open('app.log', 'r') as f:
                self._logsStr = f.read()
        except:
            pass
        self.logSignal.emit()
