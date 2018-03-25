"""
    Qt-based model Channel and EPG
"""

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty, QPoint
from PyQt5.QtQml import QQmlListProperty
from services import getChannels, getEpgList
import config
import os, io
from controllers import utils
from models import models


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
    selectedChannelIndexSignal = pyqtSignal()

    def __init__(self, connectLabel, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.connectLabel = connectLabel
        self._channels = []
        self._channelIndex = 0
        self.setChannel()

    def setChannel(self):
        self._channels = []
        channels = getChannels(self.connectLabel)
        for channel in channels:
            self._channels.append(Channel(channel))
        self.listChannels.emit()

    @pyqtProperty(QQmlListProperty, notify=listChannels)
    def channels(self):
        return QQmlListProperty(Channel, self, self._channels)

    @pyqtProperty(int, notify=selectedChannelIndexSignal)
    def selectedChannelIndex(self):
        return self._channelIndex

    chooseChannelSingal = pyqtSignal(int, arguments=['chooseChannel'])

    @pyqtSlot(int)
    def chooseChannel(self, index):
        self._channelIndex = index
        self.selectedChannelIndexSignal.emit()


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

    def updateEpg(self):
        self.listEpg.emit()

    def clearEpg(self):
        self._epglist = []
        self.updateEpg()

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

    ChangeDateEPGSignal = pyqtSignal(str, arguments=['changeDateEPG'])

    @pyqtSlot(str)
    def changeDateEPG(self, date):
        self._date = date
        self.epgDateSignal.emit()

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
        self._stateST = 0

    startTimeSignal = pyqtSignal()
    endTimeSignal = pyqtSignal()
    startTimestampSignal = pyqtSignal()
    endTimestampSignal = pyqtSignal()
    recorderSignal = pyqtSignal()
    titleSignal = pyqtSignal()
    idSignal = pyqtSignal()
    stateDLSignal = pyqtSignal()
    stateSTSignal = pyqtSignal()

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

    @pyqtProperty(int, notify=stateSTSignal)
    def stateST(self):
        return self._stateST

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

    def changeStateStore(self, state):
        self._stateST = int(state)
        self.stateSTSignal.emit()


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


class AppLogs(QObject):

    def __init__(self, logWidget, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.logWidget = logWidget
        self.appLogsIO = None
        self.vlcLogsIO = None
        self._appLogsStr = ''
        self._vlcLogsStr = ''
        self._maximizeState = False
        self.currentCP = self.logWidget.startCP
        self.openLogs()

    def openLogs(self):
        try:
            self.appLogsIO = io.open('app.log', 'r', buffering=-1, closefd=True)
        except:
            pass
        try:
            self.vlcLogsIO = io.open('vlc.log', 'r', buffering=-1, closefd=True)
        except:
            pass

    appLogSignal = pyqtSignal(str, arguments=['appLogs'])
    vlcLogSignal = pyqtSignal(str, arguments=['vlcLogs'])

    def updateLogs(self):
        try:
            readableLogs = self.appLogsIO.read()
            if len(readableLogs) is not 0:
                self._appLogsStr = readableLogs
                self.appLogSignal.emit(self._appLogsStr)
        except:
            pass
        try:
            readableLogs = self.vlcLogsIO.read()
            if len(readableLogs) is not 0:
                self._vlcLogsStr = readableLogs
                self.vlcLogSignal.emit(self._vlcLogsStr)
        except:
            pass

    clearLogsSignal = pyqtSignal(arguments=['clearLogs'])

    @pyqtSlot()
    def clearLogs(self):
        try:
            f = open('app.log', 'w')
            f.close()
        except:
            pass
        try:
            f = open('vlc.log', 'w')
            f.close()
        except:
            pass
        self.updateLogs()

    closeWindowSignal = pyqtSignal(arguments=['closeWindow'])

    @pyqtSlot()
    def closeWindow(self):
        self.logWidget.close()

    minimizeWindowSignal = pyqtSignal(arguments=['minimizeWindow'])

    @pyqtSlot()
    def minimizeWindow(self):
        self.logWidget.showMinimized()

    maximizeWindowSignal = pyqtSignal(arguments=['maximizeWindow'])

    @pyqtSlot()
    def maximizeWindow(self):
        if self._maximizeState:
            self.logWidget.resize(self.logWidget.width, self.logWidget.height)
            self.logWidget.move(self.currentCP)
        else:
            self.logWidget.resize(self.logWidget.screenSize.width(), self.logWidget.screenSize.height())
            self.logWidget.move(QPoint(0, 0))
        self._maximizeState = not self._maximizeState
        self.maximizeStateSignal.emit()

    maximizeStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=maximizeStateSignal)
    def maximizeState(self):
        return int(self._maximizeState)

    dragWindowSingal = pyqtSignal(int, int, arguments=['dragWindow'])

    @pyqtSlot(int, int)
    def dragWindow(self, attr1, attr2):
        oldPos = self.logWidget.pos()
        cp = QPoint(oldPos.x() + attr1, oldPos.y() + attr2)
        self.currentCP = cp
        self.logWidget.move(cp)


class AppSettings(QObject):

    def __init__(self, mainWindow, settingsWidget, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.mainWindow = mainWindow
        self.settingsWidget = settingsWidget
        self._maximizeState = False
        self.currentCP = self.settingsWidget.startCP

    closeWindowSignal = pyqtSignal(arguments=['closeWindow'])

    @pyqtSlot()
    def closeWindow(self):
        self.settingsWidget.close()

    minimizeWindowSignal = pyqtSignal(arguments=['minimizeWindow'])

    @pyqtSlot()
    def minimizeWindow(self):
        self.settingsWidget.showMinimized()

    maximizeWindowSignal = pyqtSignal(arguments=['maximizeWindow'])

    @pyqtSlot()
    def maximizeWindow(self):
        if self._maximizeState:
            self.settingsWidget.resize(self.settingsWidget.width, self.settingsWidget.height)
            self.settingsWidget.move(self.currentCP)
        else:
            self.settingsWidget.resize(self.settingsWidget.screenSize.width(), self.settingsWidget.screenSize.height())
            self.settingsWidget.move(QPoint(0, 0))
        self._maximizeState = not self._maximizeState
        self.maximizeStateSignal.emit()

    maximizeStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=maximizeStateSignal)
    def maximizeState(self):
        return int(self._maximizeState)

    dragWindowSingal = pyqtSignal(int, int, arguments=['dragWindow'])

    @pyqtSlot(int, int)
    def dragWindow(self, attr1, attr2):
        oldPos = self.settingsWidget.pos()
        cp = QPoint(oldPos.x() + attr1, oldPos.y() + attr2)
        self.currentCP = cp
        self.settingsWidget.move(cp)

    currentHostSignal = pyqtSignal()

    @pyqtProperty('QString', notify=currentHostSignal)
    def currentHost(self):
        return config.getHost()

    currentPortSignal = pyqtSignal()

    @pyqtProperty('QString', notify=currentPortSignal)
    def currentPort(self):
        return config.getPort()

    currentFolderSignal = pyqtSignal()

    @pyqtProperty('QString', notify=currentFolderSignal)
    def currentFolder(self):
        return config.getSavePath()

    currentStoreFolderSignal = pyqtSignal()

    @pyqtProperty('QString', notify=currentStoreFolderSignal)
    def currentStoreFolder(self):
        return config.getStorePath()

    changeHostAndPortSignal = pyqtSignal(str, str, arguments=['changeHostAndPort'])

    @pyqtSlot(str, str)
    def changeHostAndPort(self, host, port):
        config.setConfig('URL', 'host', host)
        config.setConfig('URL', 'port', port)
        self.currentHostSignal.emit()
        self.currentPortSignal.emit()
        self.mainWindow.listChannels.setChannel()
        try:
            self.mainWindow.listEpg.setEpg(address=self.mainWindow.listChannels._channels[0]._channel_address)
            self.mainWindow.listEpg.updateEpg()
        except:
            self.mainWindow.listEpg.clearEpg()
        self.mainWindow.videoControls.stopped()
        utils.clearVideoFrame(self.mainWindow)
        self.mainWindow.child_position = None
        self.mainWindow.child_epg = None
        self.mainWindow.custom_epg = False
        self.mainWindow.media_state = False
        self.mainWindow.listSegmentPostiton.deleteAllSegment()
        self.mainWindow.current_epg_obj = None
        self.mainWindow.focusState.setMediaSetState(0)

        emptyEpgObj = models.EPG.create()
        emptyEpgQObj = EPG(emptyEpgObj)
        self.mainWindow.selectedEPG.setSelectedEPG(emptyEpgQObj)

    changeSavePathSignal = pyqtSignal(str, arguments=['changeSavePath'])

    @pyqtSlot(str)
    def changeSavePath(self, path):
        holyPath = path[8:]
        config.setConfig('SAVE', 'path', holyPath)
        self.currentFolderSignal.emit()

    changeStorePathSignal = pyqtSignal(str, arguments=['changeStorePath'])

    @pyqtSlot(str)
    def changeStorePath(self, path):
        holyPath = path[8:]
        config.setConfig('STORE', 'path', holyPath)
        self.currentStoreFolderSignal.emit()

# class ReaderLogs(threading.Thread):
#
#     def __init__(self, pathUrl, path_to_save):
#         super().__init__()
#         self.state = False
#         self.pathUrl = pathUrl
#         self.path_to_save = path_to_save
#
#     def run(self):
#         r = requests.get(self.pathUrl, stream=True)
#         if r.status_code == 200:
#             with open(self.path_to_save, "wb") as f:
#                 for chunk in r.iter_content(1024):
#                     f.write(chunk)
#         self.state = True