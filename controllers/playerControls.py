"""
    Player controls classes
"""

from PyQt5.QtCore import Qt, QPoint
from PyQt5.QtWidgets import (QWidget)
from PyQt5.QtGui import QPalette, QColor, QPainter, QBrush, QPen
from models.qmodels import *
import datetime
import config
import time
import math


class PlayerControls(QObject):

    def __init__(self, mainWindow):
        super().__init__()
        self.mainWindow = mainWindow
        self.mediaplayer = self.mainWindow.vlcPlayer.mediaplayer

    #  close and minimizes signals
    def addTopElemSignals(self):
        self.topElem = self.mainWindow.topElem.quickView.rootObject()
        self.topElem.closeSignal.connect(self.mainWindow.hide)
        self.topElem.minimizeSignal.connect(self.mainWindow.showMinimized)

    # play/stop/pause video signals
    def addmiddleElemSignals(self):

        self.middleElem = self.mainWindow.middleElem.quickView.rootObject()
        self.middleElem.stopStartVideoSignal.connect(self.playStopVideo)
        self.middleElem.pauseVideoSignal.connect(self.pauseVideo)

    def playStopVideo(self):
        if self.mainWindow.vlcPlayer.mediaplayer.is_playing():
            self.mainWindow.vlcPlayer.mediaplayer.stop()
            self.mainWindow.video_time = 0  # ???
        else:
            self.mainWindow.vlcPlayer.mediaplayer.play()
            self.timer_flag = True

    def pauseVideo(self):
        self.mainWindow.vlcPlayer.mediaplayer.pause()

    chooseEPGSingal = pyqtSignal(str, str, str, str, str, arguments=['chooseEPG'])

    @pyqtSlot(str, str, str, str, str)
    def chooseEPG(self, startTime, endTime, date, recorder, id):
        self.mainWindow.child_position = None
        self.mainWindow.child_epg = None
        startDateTimeStr = '{};{}'.format(startTime, date)
        endDateTimeStr = '{};{}'.format(endTime, date)
        startDateTime = datetime.datetime.strptime(startDateTimeStr, "%H:%M:%S;%d.%m.%Y")
        endDateTime = datetime.datetime.strptime(endDateTimeStr, "%H:%M:%S;%d.%m.%Y")
        startTimesTamp = int(time.mktime(startDateTime.timetuple()))
        endTimesTamp = int(time.mktime(endDateTime.timetuple()))

        self.mainWindow.current_epg = {'startTimesTamp': startTimesTamp,
                                       'endTimesTamp': endTimesTamp,
                                       'recorder': recorder}

        self.mainWindow.videoData = (startTimesTamp, endTimesTamp)
        print('videoData', self.mainWindow.videoData)
        epg_url = '{0}{1}.record?from={2}&to={3}'.format(config.mediahost, recorder, str(startTimesTamp), str(endTimesTamp))

        epg_name = '{0}_{1}-{2}'.format(id, startTimesTamp, endTimesTamp)
        print('nameChoosing', epg_name)
        print(epg_url)
        # self.epg_local_path = self.mainWindow.vlcRecorder.getFromSource(epg_url, epg_name)
        self.mainWindow.vlcPlayer.setMedia(epg_url)

    leftMinSeekSingal = pyqtSignal(int, arguments=['leftMinSeek'])

    @pyqtSlot(int)
    def leftMinSeek(self, attr):
        self.seek_video(attr, "-")

    rightMinSeekSingal = pyqtSignal(int, arguments=['rightMinSeek'])

    @pyqtSlot(int)
    def rightMinSeek(self, attr):
        self.seek_video(attr, "+")

    leftSecSeekSingal = pyqtSignal(int, arguments=['leftSecSeek'])

    @pyqtSlot(int)
    def leftSecSeek(self, attr):
        self.seek_video(attr, "-")

    rightSecSeekSingal = pyqtSignal(int, arguments=['rightSecSeek'])

    @pyqtSlot(int)
    def rightSecSeek(self, attr):
        self.seek_video(attr, "+")

    def seek_video(self, value, operator="+"):
        if self.mainWindow.videoData is None:
            videoLength = 0
        else:
            videoLength = self.mainWindow.videoData[1] - self.mainWindow.videoData[0]
        print('videoData', self.mainWindow.videoData)
        print('videoLength', videoLength)
        cur_videoPosition = self.mediaplayer.get_position()
        cur_relPosition = videoLength * cur_videoPosition
        rel_seek_value = value / 1000
        print('relPos', cur_relPosition)
        new_relPosition = 0
        print('value', value)
        if operator == '-':
            new_relPosition = cur_relPosition - rel_seek_value
        else:
            new_relPosition = cur_relPosition + rel_seek_value
        new_videoPosition = new_relPosition / videoLength
        if new_videoPosition > 0:
            self.mediaplayer.set_position(new_videoPosition)
        else:
            self.mediaplayer.set_position(0)

    startTimeSegmentValue = ''
    endTimeSegmentValue = ''

    startTimeSegmentSignal = pyqtSignal()

    @pyqtProperty('QString', notify=startTimeSegmentSignal)
    def startTimeSegment(self):
        value = self.startTimeSegmentValue
        self.startTimeSegmentValue = ''
        return value

    getStartTimeSegmentSingal = pyqtSignal(arguments=['getStartTimeSegment'])

    @pyqtSlot()
    def getStartTimeSegment(self):
        # videoLength = self.mainWindow.current_epg.get('endTimesTamp') - self.mainWindow.current_epg.get(
        #     'startTimesTamp')
        # currentPosVideoSecond = int(videoLength * self.mediaplayer.get_position())
        # current_start_time = self.mainWindow.current_epg.get('startTimesTamp') + currentPosVideoSecond
        self.startTimeSegmentValue = str(datetime.datetime.now())
        self.startTimeSegmentSignal.emit()

    endTimeSegmentSignal = pyqtSignal()

    @pyqtProperty('QString', notify=endTimeSegmentSignal)
    def endTimeSegment(self):
        value = self.endTimeSegmentValue
        self.endTimeSegmentValue = ''
        return value

    getEndTimeSingal = pyqtSignal(arguments=['getEndTimeSegment'])

    @pyqtSlot()
    def getEndTimeSegment(self):
        # videoLength = self.mainWindow.current_epg.get('endTimesTamp') - self.mainWindow.current_epg.get(
        #     'startTimesTamp')
        # currentPosVideoSecond = int(videoLength * self.mediaplayer.get_position())
        # current_end_time = self.mainWindow.current_epg.get('startTimesTamp') + currentPosVideoSecond

        self.endTimeSegmentValue = str(datetime.datetime.now())
        self.endTimeSegmentSignal.emit()


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
        if self.mainWindow.child_epg is None:
            self.videoSliderPosition = self.mediaplayer.get_position() * 1000
            self.mainWindow.child_position = self.videoSliderPosition / 1000
        else:
            self.videoSliderPosition = self.childSliderPositionStart + (self.mediaplayer.get_position() * (1 - self.videoSliderParentPosition)) * 1000
            self.mainWindow.child_position = self.videoSliderPosition / 1000

    @pyqtProperty('int', notify=sliderPosSignal)
    def sliderValue(self):
        return self.videoSliderPosition

    def updateSliderPos(self):
        self.getSliderPos()
        self.sliderPosSignal.emit()

    sliderHandle = pyqtSignal(int, arguments=['changePosition'])

    @pyqtSlot(int)
    def changePosition(self, sliderPosition):
        self.setVideoPos(sliderPosition)

    def setVideoPos(self, sliderPosition):
        self.childSliderPositionStart = sliderPosition
        if self.videoSliderParentPosition is None:
            self.videoSliderParentPosition = self.mediaplayer.get_position()
        self.mainWindow.vlcPlayer.mediaplayer.pause()
        videoPosition = self.mediaplayer.get_position()
        self.cur_epg = self.mainWindow.current_epg
        self.child_epg = {'startTimesTamp': self.cur_epg.get('startTimesTamp') + sliderPosition,
                          'endTimesTamp': self.cur_epg.get('endTimesTamp'),
                          'recorder': self.cur_epg.get('recorder')}
        self.mainWindow.child_epg = self.child_epg
        epg_url = '{0}{1}.record?from={2}&to={3}'.format(config.mediahost, self.child_epg.get('recorder'),
                                                         str(self.child_epg.get('startTimesTamp')),
                                                         str(self.child_epg.get('endTimesTamp')))
        self.mainWindow.vlcPlayer.mediaplayer.pause()
        self.mainWindow.vlcPlayer.setMedia(epg_url)
        self.mainWindow.vlcPlayer.mediaplayer.play()


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
        if self.mainWindow.videoData is None:
            self.videoLength = 0
        else:
            self.videoLength = self.mainWindow.videoData[1] - self.mainWindow.videoData[0]
        # self.videoLength = self.mediaplayer.get_length()
        if self.mainWindow.child_epg is None:
            videoPosition = self.mediaplayer.get_position()
        else:
            videoPosition = self.mainWindow.child_position
            # print('childPos', videoPosition)
        relPosition = self.videoLength * videoPosition
        if relPosition < 0:
            relPosition = 0
        date = datetime.datetime.fromtimestamp(relPosition)
        time = date.time()
        # print(time)
        # try:
        #     print('videoPositionDel', (videoPosition - self.prefPos)*1000)
        # except:
        #     pass
        self.prefPos = videoPosition

        # absHours = relPosition // 3600000
        # absMinutes = relPosition // 60000
        # absSeconds = relPosition // 1000
        # hours = absHours
        # if int(absMinutes) < 60:
        #     minutes = str(int(absMinutes))
        # else:
        #     minutes = str(int(absMinutes % 60))
        #
        # if int(absSeconds) < 60:
        #     seconds = str(int(absSeconds))
        # else:
        #     seconds = str(int(absSeconds % 60))
        #
        # if int(hours) < 10:
        #     hours = "0" + str(int(hours))
        #
        # if int(minutes) < 10:
        #     minutes = "0" + str(int(minutes))
        #
        # if int(seconds) < 10:
        #     seconds = "0" + str(int(seconds))

        # self.videoHumanPostiton = hours + ":" + minutes + ":" + seconds

    @pyqtProperty('QString', notify=timerValueSignal)
    def timerValue(self):
        return self.videoHumanPostiton

    def updateTimer(self):

        self.videoPosToTimer()
        # print('Human Position', self.videoHumanPostiton)
        self.timerValueSignal.emit()

    def timer_update(self):
        if self.mainWindow.timer_flag:
            self.mainWindow.video_time += self.mainWindow.timerDuration


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
            # print((self.counter) % 6)
            if ((self.counter) % 6) // 1 == i:
                # painter.setBrush(QBrush(QColor(127 + (self.counter % 5)*32, 127, 127)))
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
            self.killTimer(self.timer)
            # self.hide()


class WindowControlsOlD(QObject):

    def __init__(self, mainWindow, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.mainWindow = mainWindow

    dragWindowSingal = pyqtSignal(int, int, arguments=['dragWindow'])

    @pyqtSlot(int, int)
    def dragWindow(self, attr1, attr2):
        oldPos = self.mainWindow.pos()
        cp = QPoint(oldPos.x() + attr1, oldPos.y() + attr2)
        self.mainWindow.move(cp)


