"""
    Player controls classes
"""

from PyQt5.QtCore import Qt, QPoint
from PyQt5.QtWidgets import QWidget, QFileDialog
from PyQt5.QtGui import QPalette, QColor, QPainter, QBrush, QPen
from models.qmodels import *
import datetime
import config
import time
import math
import logging
from vlcMedia import VlcRecorder
from controllers import utils
import vlc
from models import models
import urllib.request

module_logger = logging.getLogger("app.appControls")


class WindowControls(QObject):
    logger = logging.getLogger("app.appControls.windowControls")

    def __init__(self, mainWindow):
        super().__init__()
        self.mainWindow = mainWindow
        self._maximizeState = False

    closeWindowSignal = pyqtSignal(arguments=['closeWindow'])

    @pyqtSlot()
    def closeWindow(self):
        self.mainWindow.settingsWindow.close()
        self.mainWindow.logsWindow.close()
        self.mainWindow.close()

    minimizeWindowSignal = pyqtSignal(arguments=['minimizeWindow'])

    @pyqtSlot()
    def minimizeWindow(self):
        self.mainWindow.showMinimized()

    maximizeWindowSignal = pyqtSignal(arguments=['maximizeWindow'])

    @pyqtSlot()
    def maximizeWindow(self):
        if self._maximizeState:
            self.mainWindow.resize(self.mainWindow.currentWidth, self.mainWindow.currentHeight)
            self.mainWindow.move(self.mainWindow.currentCP)
        else:
            self.mainWindow.resize(self.mainWindow.screenSize.width(), self.mainWindow.screenSize.height())
            self.mainWindow.move(QPoint(0, 0))
        self._maximizeState = not self._maximizeState
        self.maximizeStateSignal.emit()

    maximizeStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=maximizeStateSignal)
    def maximizeState(self):
        return int(self._maximizeState)

    dragWindowSingal = pyqtSignal(int, int, arguments=['dragWindow'])

    @pyqtSlot(int, int)
    def dragWindow(self, attr1, attr2):
        oldPos = self.mainWindow.pos()
        cp = QPoint(oldPos.x() + attr1, oldPos.y() + attr2)
        self.mainWindow.currentCP = cp
        self.mainWindow.move(cp)

    openLogsSignal = pyqtSignal(arguments=['openLogs'])

    @pyqtSlot()
    def openLogs(self):
        self.mainWindow.logsWindow.show()
        self.mainWindow.appLogs.updateLogs()

    openSettingsSignal = pyqtSignal(arguments=['openSettings'])

    @pyqtSlot()
    def openSettings(self):
        self.mainWindow.settingsWindow.show()


class VideoControls(QObject):
    logger = logging.getLogger("app.appControls.videoControls")

    def __init__(self, mainWindow):
        super().__init__()
        self.mainWindow = mainWindow
        self._startStopState = 0
        self._pauseState = 0
        self._volume = 80
        self._volumeMute = 100
        self.volumeSet(self._volume)
        self.mediaplayer = self.mainWindow.vlcPlayer.mediaplayer
        self._extractingState = 0
        self._storingState = 0

    def stopped(self):
        self.mainWindow.vlcPlayer.mediaplayer.stop()
        self.mainWindow.vlcPlayer.mediaplayer.set_position(0)
        self._pauseState = 0
        self.pauseStateSignal.emit()
        self.mainWindow.timePostitonSecond = 0

    startStopStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=startStopStateSignal)
    def startStopState(self):
        return self._startStopState

    playStopVideoSignal = pyqtSignal(arguments=['playStopVideo'])

    @pyqtSlot()
    def playStopVideo(self):
        if self.mainWindow.vlcPlayer.mediaplayer.is_playing() or self._pauseState == 1:
            self.stopped()
            try:
                self.mainWindow.vlcPlayer.setMedia(self.mainWindow.current_epg.get('url'))
            except:
                pass
            utils.clearWaitingFrame()
            self.startStopStateSignal.emit()
            self.mainWindow.updateWindow()
        else:
            if self.mainWindow.media_state and self._pauseState == 0:
                self.mainWindow.vlcPlayer.mediaplayer.play()
                self.volumeSet(self._volume)

    pauseStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=pauseStateSignal)
    def pauseState(self):
        return self._pauseState

    pauseVideoSignal = pyqtSignal(arguments=['pauseVideo'])

    @pyqtSlot()
    def pauseVideo(self):
        if self.mainWindow.vlcPlayer.mediaplayer.is_playing() and self._pauseState == 0:
            self.mainWindow.vlcPlayer.mediaplayer.pause()
            self._pauseState = 1
            self.mainWindow.timer_flag = False
        elif self._pauseState == 1:
            self.mainWindow.vlcPlayer.mediaplayer.play()
            self._pauseState = 0
            self.mainWindow.timer_flag = True
        self.pauseStateSignal.emit()

    def updateStateVideo(self):
        if self.mainWindow.vlcPlayer.mediaplayer.is_playing() or self._pauseState == 1:
            self._startStopState = 1
            self.mainWindow.timer_flag = True
        else:
            self._startStopState = 0
        self.startStopStateSignal.emit()

    volumeSignal = pyqtSignal()

    @pyqtProperty(int, notify=volumeSignal)
    def volume(self):
        return self._volume

    volumeChangeSignal = pyqtSignal(int, arguments=['volumeChange'])

    @pyqtSlot(int)
    def volumeChange(self, value):
        self.volumeSet(value)

    def volumeSet(self, value):
        self._volume = value
        self.mainWindow.vlcPlayer.mediaplayer.audio_set_volume(value)
        self.volumeSignal.emit()

    volumeMuteSignal = pyqtSignal(arguments=['volumeMute'])

    @pyqtSlot()
    def volumeMute(self):
        if self._volume > 0:
            self._volumeMute = self._volume
            self._volume = 0
        else:
            self._volume = self._volumeMute
        self.mainWindow.vlcPlayer.mediaplayer.audio_set_volume(self._volume)
        self.volumeSignal.emit()

    chooseEPGSingal = pyqtSignal(str, str, str, str, str, str, int, arguments=['chooseEPG'])

    @pyqtSlot(str, str, str, str, str, str, int)
    def chooseEPG(self, startTime, endTime, date, recorder, id, title, index):
        self.stopped()
        utils.clearVideoFrame(self.mainWindow)
        self.mainWindow.child_position = None
        self.mainWindow.child_epg = None
        startDateTimeStr = '{};{}'.format(startTime, date)
        endDateTimeStr = '{};{}'.format(endTime, date)
        startDateTime = datetime.datetime.strptime(startDateTimeStr, "%H:%M:%S;%d.%m.%Y")
        endDateTime = datetime.datetime.strptime(endDateTimeStr, "%H:%M:%S;%d.%m.%Y")
        startTimesTamp = int(time.mktime(startDateTime.timetuple()))
        endTimesTamp = int(time.mktime(endDateTime.timetuple()))

        self.mainWindow.custom_epg = False

        epg_url = '{0}{1}.record?from={2}&to={3}'.format(config.getMediaUrl(), recorder, str(startTimesTamp), str(endTimesTamp))
        # self.mainWindow.current_epg['startTimesTamp'] = startTimesTamp
        # self.mainWindow.current_epg['endTimesTamp'] = endTimesTamp
        # self.mainWindow.current_epg['recorder'] =  recorder
        # self.mainWindow.current_epg['title'] = title
        # self.mainWindow.current_epg['url'] = epg_url
        self.mainWindow.current_epg = {'startTimesTamp': startTimesTamp,
                                       'endTimesTamp': endTimesTamp,
                                       'recorder': recorder,
                                       'title': title,
                                       'url': epg_url}

        self.mainWindow.current_epg_obj = self.mainWindow.listEpg.epg_list[index]
        self.mainWindow.selectedEPG.setSelectedEPG(self.mainWindow.current_epg_obj)

        self.mainWindow.videoData = (startTimesTamp, endTimesTamp)

        epg_name = '{0}_{1}-{2}'.format(id, startTimesTamp, endTimesTamp)
        try:
            code = urllib.request.urlopen(epg_url).getcode()
        except:
            code = 0
        self.mainWindow.focusState.setFocusState(0)

        if code == 200:
            # self.mainWindow.current_epg['mediaUrl'] = config.getMediaUrl()
            self.mainWindow.vlcPlayer.setMedia(epg_url)
            self.mainWindow.media_state = True
            self.mainWindow.focusState.setMediaSetState(1)
            self.mainWindow.listSegmentPostiton.deleteAllSegment()
            self.mainWindow.status.setStatusText('')
        if code == 0:
            self.mainWindow.focusState.setMediaSetState(0)
            self.mainWindow.media_state = False
            self.mainWindow.status.setStatusText(self.mainWindow.status.epgNotAvailable)

    leftMinSeekSingal = pyqtSignal(int, arguments=['leftMinSeek'])

    @pyqtSlot(int)
    def leftMinSeek(self, attr):
        if self.mainWindow.media_state:
            self.seek_video(attr, "-")

    rightMinSeekSingal = pyqtSignal(int, arguments=['rightMinSeek'])

    @pyqtSlot(int)
    def rightMinSeek(self, attr):
        if self.mainWindow.media_state:
            self.seek_video(attr, "+")

    leftSecSeekSingal = pyqtSignal(int, arguments=['leftSecSeek'])

    @pyqtSlot(int)
    def leftSecSeek(self, attr):
        if self.mainWindow.media_state:
            self.seek_video(attr, "-")

    rightSecSeekSingal = pyqtSignal(int, arguments=['rightSecSeek'])

    @pyqtSlot(int)
    def rightSecSeek(self, attr):
        if self.mainWindow.media_state:
            self.seek_video(attr, "+")

    def seek_video(self, value, operator="+"):
        utils.setVideoPos(self.mainWindow, shiftValue=value, shiftDir=operator)
        self._pauseState = 0
        self.pauseStateSignal.emit()
        utils.clearWaitingFrame()

    getStartTimeSegmentSingal = pyqtSignal(arguments=['getStartTimeSegment'])

    @pyqtSlot()
    def getStartTimeSegment(self):
        if self.mainWindow.current_epg_obj is not None:
            self.startTimeSegmentTimestamp, curPositionSecond = self.getTimestampSegment()

            # self.startTimeSegmentValue = utils.timeInt2Str(curPositionSecond * 1000)
            self.startTimeSegmentValue = utils.timestamp2str(self.startTimeSegmentTimestamp)

            self.mainWindow.listSegmentPostiton.setStartSegment(self.startTimeSegmentValue,
                                                                self.startTimeSegmentTimestamp,
                                                                self.mainWindow.current_epg_obj.recorder,
                                                                self.mainWindow.current_epg_obj.title,
                                                                self.mainWindow.current_epg_obj.id)

    getEndTimeSegmentSingal = pyqtSignal(arguments=['getEndTimeSegment'])

    @pyqtSlot()
    def getEndTimeSegment(self):
        if self.mainWindow.current_epg_obj is not None and \
                (self.mainWindow.vlcPlayer.mediaplayer.get_state() == vlc.State.Playing or
                 self.mainWindow.vlcPlayer.mediaplayer.get_state() == vlc.State.Paused):
            self.endTimeSegmentTimestamp, curPositionSecond = self.getTimestampSegment()

            # self.endTimeSegmentValue = utils.timeInt2Str(curPositionSecond * 1000)
            self.endTimeSegmentValue = utils.timestamp2str(self.endTimeSegmentTimestamp)

            self.mainWindow.listSegmentPostiton.setEndSegment(self.endTimeSegmentValue,
                                                              self.endTimeSegmentTimestamp,
                                                              self.mainWindow.current_epg_obj.id)

    def getTimestampSegment(self):
        curPosSecond = self.mainWindow.timePostitonSecond
        startTimesamp = self.mainWindow.current_epg.get('startTimesTamp')
        positionTimesamp = startTimesamp + curPosSecond
        return positionTimesamp, curPosSecond

    deleteTimeSegmentSigna = pyqtSignal(int, arguments=['deleteTimeSegment'])

    @pyqtSlot(int)
    def deleteTimeSegment(self, attr):
        self.mainWindow.listSegmentPostiton.deleteSegment(attr)

    extractSignal = pyqtSignal(arguments=['extract'])

    @pyqtSlot()
    def extract(self):
        save_path = config.getSavePath()
        if save_path is None:
            save_path = str(QFileDialog.getExistingDirectory(self.mainWindow, 'Save path'))
            config.setConfig('SAVE', 'path', save_path)
            self.mainWindow.appSettings.currentFolderSignal.emit()
        if len(save_path) is not 0:
            recorder = VlcRecorder(self.mainWindow, save_path)
            recorder.extract(self.mainWindow.listSegmentPostiton.segment_list)

    extractingStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=extractingStateSignal)
    def extractingState(self):
        return self._extractingState

    def changeExtractingState(self, value):
        self._extractingState = value
        self.extractingStateSignal.emit()

    storeSignal = pyqtSignal(arguments=['store'])

    @pyqtSlot()
    def store(self):
        save_path = config.getStorePath()
        if save_path is None:
            save_path = str(QFileDialog.getExistingDirectory(self.mainWindow, 'Save path'))
            config.setConfig('STORE', 'path', save_path)
            self.mainWindow.appSettings.currentStoreFolderSignal.emit()
        if len(save_path) is not 0:
            recorder = VlcRecorder(self.mainWindow, save_path)
            recorder.store(self.mainWindow.listSegmentPostiton.segment_list)

    storingStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=storingStateSignal)
    def storingState(self):
        return self._storingState

    def changeStoringState(self, value):
        self._storingState = value
        self.storingStateSignal.emit()


class VideoSlider(QObject):

    def __init__(self, mainWindow, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.mainWindow = mainWindow
        self.mediaplayer = self.mainWindow.vlcPlayer.mediaplayer
        self.videoSliderPosition = int()
        self.videoSliderParentPosition = None
        self.videoSliderChildPosition = None

    sliderPosSignal = pyqtSignal()

    def getSliderPos(self):
        epg_obj = self.mainWindow.current_epg_obj
        if epg_obj is not None:
            duration_seconds = utils.getDurationSeconds(self.mainWindow)
            self.videoSliderPosition = 1000 / duration_seconds * self.mainWindow.timePostitonSecond
        else:
            self.videoSliderPosition = 0

    @pyqtProperty('int', notify=sliderPosSignal)
    def sliderValue(self):
        return self.videoSliderPosition

    def updateSliderPos(self):
        self.getSliderPos()
        self.sliderPosSignal.emit()

    sliderHandle = pyqtSignal(int, arguments=['changePosition'])

    @pyqtSlot(int)
    def changePosition(self, sliderPosition):
        utils.setVideoPos(self.mainWindow, sliderPosition)
        # self.mainWindow.video_time = sliderPosition / self.mainWindow.rel_slider_time
        # self.mainWindow.video_time = sliderPosition / self.mainWindow.timePostitonSecond

    def setPositionSlider(self, val):
        self.videoSliderPosition = val
        self.sliderPosSignal.emit()


class VideoTimer(QObject):

    def __init__(self, mainWindow, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.mainWindow = mainWindow
        self.mediaplayer = self.mainWindow.vlcPlayer.mediaplayer
        self.videoHumanPostiton = str()
        self.videoLength = None

    timerValueSignal = pyqtSignal()

    def setVideo(self, startTimesTamp, endTimesTamp):
        self.videoLength = endTimesTamp - startTimesTamp

    def videoPosToTimer(self):
        try:
            self.startTimestamp = self.mainWindow.current_epg.get('startTimesTamp', 0)
        except:
            self.startTimestamp = 0
        current_time = self.mainWindow.timePostitonSecond
        self.videoHumanPostiton = utils.timeInt2Str(self.startTimestamp, current_time)

    @pyqtProperty('QString', notify=timerValueSignal)
    def timerValue(self):
        return self.videoHumanPostiton

    def updateTimer(self):
        self.videoPosToTimer()
        self.timerValueSignal.emit()

    def setPositionTimer(self, val):
        self.videoHumanPostiton = utils.timeInt2Str(val)
        self.timerValueSignal.emit()


class WaitIndicator(QWidget):

    def __init__(self, parent=None):

        super().__init__(parent)
        palette = QPalette(self.palette())
        palette.setColor(palette.Background, Qt.transparent)
        self.setPalette(palette)

    def paintEvent(self, event):

        painter = QPainter()
        painter.begin(self)
        painter.setRenderHint(QPainter.Antialiasing)
        painter.fillRect(event.rect(), QBrush(QColor("transparent")))
        painter.setPen(QPen(Qt.NoPen))

        for i in range(6):
            if ((self.counter) % 6) // 1 == i:
                painter.setBrush(QBrush(QColor(27, 23, 37)))
            else:
                painter.setBrush(QBrush(QColor(171, 162, 195)))
            painter.drawEllipse(
                self.width() / 3 + 30 * math.cos(2 * math.pi * i / 6.0) - 30,
                self.height() / 3 + 30 * math.sin(2 * math.pi * i / 6.0) - 10,
                20, 20)

        painter.end()

    def showEvent(self, event):

        self.timer = self.startTimer(70)
        self.counter = 0

    def timerEvent(self, event):
        self.counter += 1
        self.update()
        if self.counter == 60:
            self.counter = 0


class CustomEpgControls(QObject):

    def __init__(self, mainWindow):
        super().__init__()
        self.mainWindow = mainWindow
        self.mediaplayer = self.mainWindow.vlcPlayer.mediaplayer

    dateTimeEditSignal = pyqtSignal(str, str, str, str, arguments=['dateTimeEdit'])

    @pyqtSlot(str, str, str, str)
    def dateTimeEdit(self, date, startTime, endTime, recorder):
        try:
            self.setCustomEpg(date, startTime, endTime, recorder)
        except:
            pass

    def setCustomEpg(self, date, startTime, endTime, recorder):
        self.mainWindow.videoControls.stopped()
        utils.clearVideoFrame(self.mainWindow)
        startTimestamp = utils.convertToTimestamp(startTime, date)
        endTimestamp = utils.convertToTimestamp(endTime, date)
        self.mainWindow.custom_epg = True

        custom_epg = models.EPG.create(date=date, startTime=startTime, endTime=endTime, recorder=recorder)
        custom_epg_obj = EPG(custom_epg)
        self.mainWindow.current_epg_obj = custom_epg_obj

        epg_url = '{0}{1}.record?from={2}&to={3}'.format(config.getMediaUrl(),
                                                         recorder,
                                                         str(startTimestamp),
                                                         str(endTimestamp))

        # self.mainWindow.current_epg['startTimesTamp'] = startTimestamp
        # self.mainWindow.current_epg['endTimesTamp'] = endTimestamp
        # self.mainWindow.current_epg['url'] = epg_url
        # self.mainWindow.current_epg['recorder'] = recorder
        self.mainWindow.current_epg = {'startTimesTamp': startTimestamp,
                                       'endTimesTamp': endTimestamp,
                                       'recorder': recorder,
                                       'title': None,
                                       'url': epg_url}

        epg_name = '{0}_{1}-{2}'.format(id, startTimestamp, endTimestamp)
        try:
            code = urllib.request.urlopen(epg_url).getcode()
        except:
            code = 0
        self.mainWindow.focusState.setFocusState(1)
        if code == 200:
            # self.mainWindow.current_epg['mediaUrl'] = config.getMediaUrl()
            self.mainWindow.vlcPlayer.setMedia(epg_url)
            self.mainWindow.media_state = True
            self.mainWindow.focusState.setMediaSetState(1)
            self.mainWindow.listSegmentPostiton.deleteAllSegment()
            self.mainWindow.status.setStatusText('')
        if code == 0:
            self.mainWindow.focusState.setMediaSetState(0)
            self.mainWindow.media_state = False
            self.mainWindow.status.setStatusText(self.mainWindow.status.fragmentNotAvailable)

class FocusState(QObject):

    def __init__(self):
        super().__init__()
        self._focusState = 0
        self._mediaSetState = 0

    focusStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=focusStateSignal)
    def focusState(self):
        return self._focusState

    def setFocusState(self, arg):
        self._focusState = arg
        self.focusStateSignal.emit()

    mediaSetStateSignal = pyqtSignal()

    @pyqtProperty(int, notify=mediaSetStateSignal)
    def mediaSetState(self):
        return self._mediaSetState

    def setMediaSetState(self, value):
        self._mediaSetState = value
        self.mediaSetStateSignal.emit()


class Status(QObject):

    def __init__(self):
        super().__init__()
        self._statusText = ''

    epgNotAvailable = 'Epg is not available'
    # epgNotAvailable = 'The selected epg is not available'
    fragmentNotAvailable = 'Epg is not available'
    # fragmentNotAvailable = 'The video clip in these timelines is not available'

    statusTextSignal = pyqtSignal()

    @pyqtProperty('QString', notify=statusTextSignal)
    def statusText(self):
        return self._statusText

    def setStatusText(self, arg):
        self._statusText = str(arg)
        self.statusTextSignal.emit()