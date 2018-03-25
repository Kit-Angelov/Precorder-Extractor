"""
    VLC
"""

import sys, os
from PyQt5.QtCore import QUrl, Qt, QObject, pyqtSignal, pyqtSlot, pyqtProperty, QTimer
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                             QGridLayout, QFrame, QDesktopWidget, QSystemTrayIcon, QMenu, QAction, QComboBox, QLabel)
from PyQt5.QtGui import QPalette, QColor, QIcon
from PyQt5.QtQuick import QQuickView, QQuickItem
import vlc
import config
from uuid import uuid4
from os.path import expanduser
import subprocess
import requests
import threading


class VlcRecorder():

    def __init__(self, mainWindow, save_path):
        self.mainWindow = mainWindow
        self.save_path = save_path

    def getFromSource(self, sourcUrl=None, sourceName=None):
        self.instance = vlc.Instance()
        self.mediaplayer = self.instance.media_player_new()
        if len(sourceName) == 0 or sourceName is None or len(sourcUrl) == 0 or sourcUrl is None:
            return None
        path_to_save = os.path.join(config.temp_media, '{}.mpg'.format(sourceName))
        rec_instance = vlc.Instance("--sout=file/ts:{0}".format(path_to_save))
        try:
            media = rec_instance.media_new(sourcUrl)
        except NameError:
            sys.exit(1)
        rec = rec_instance.media_player_new()
        rec.set_media(media)
        rec.play()
        return path_to_save

    def extract(self, listSegments):
        # self.mainWindow.listExtractingPlayers = []
        old_extracted = self.mainWindow.listExtractingPlayers
        old_items = []
        for elem in old_extracted:
            old_items.append(elem.get('segment'))
        listExtracted = listSegments
        for item in listExtracted:
            if item.startTimestamp != 0 and item.endTimestamp != 0 and item not in old_items:

                url = '{0}{1}.record?from={2}&to={3}'.format(config.getMediaUrl(),
                                                             str(item.recorder),
                                                             str(int(item.startTimestamp)),
                                                             str(int(item.endTimestamp)))
                startTime = '_'.join(str(item.startTime).split(':'))
                endTime = '_'.join(str(item.endTime).split(':'))
                name = '_'.join(str(item.title).split(' '))
                name = '_'.join(str(name).split(':'))
                name = '_'.join(str(name).split('.'))
                name = '_'.join([str(name), startTime, endTime])
                home = expanduser("~")
                # dir_to_save = os.path.join(home, config.temp_media)
                dir_to_save = self.save_path
                if not os.path.exists(dir_to_save):
                    os.mkdir(dir_to_save)
                path_to_save = os.path.join(dir_to_save, '{}.ts'.format(name))
                # rec_instance = vlc.Instance('--sout=file/ts:{0}'.format(path_to_save))
                # media = rec_instance.media_new(url)
                # rec = rec_instance.media_player_new()
                # rec.set_media(media)
                # rec.play()
                downloader = Downloader(url, path_to_save)
                item.changeState(1)
                self.mainWindow.listExtractingPlayers.append({'rec': downloader, 'segment': item})
                downloader.start()
        self.mainWindow.listSegmentPostiton.update()

    def store(self, listSegments):
        # self.mainWindow.listExtractingPlayers = []
        old_stored = self.mainWindow.listStoringPlayers
        old_items = []
        for elem in old_stored:
            old_items.append(elem.get('segment'))
        listStored = listSegments
        for item in listStored:
            if item.startTimestamp != 0 and item.endTimestamp != 0 and item not in old_items:

                url = '{0}{1}.record?from={2}&to={3}'.format(config.getMediaUrl(),
                                                             str(item.recorder),
                                                             str(int(item.startTimestamp)),
                                                             str(int(item.endTimestamp)))
                startTime = '_'.join(str(item.startTime).split(':'))
                endTime = '_'.join(str(item.endTime).split(':'))
                name = '_'.join(str(item.title).split(' '))
                name = '_'.join(str(name).split(':'))
                name = '_'.join(str(name).split('.'))
                name = '_'.join([str(name), startTime, endTime])
                home = expanduser("~")
                # dir_to_save = os.path.join(home, config.temp_media)
                dir_to_save = self.save_path
                if not os.path.exists(dir_to_save):
                    os.mkdir(dir_to_save)
                path_to_save = os.path.join(dir_to_save, '{}.ts'.format(name))
                # rec_instance = vlc.Instance('--sout=file/ts:{0}'.format(path_to_save))
                # media = rec_instance.media_new(url)
                # rec = rec_instance.media_player_new()
                # rec.set_media(media)
                # rec.play()
                downloader = Downloader(url, path_to_save)
                item.changeStateStore(1)
                self.mainWindow.listStoringPlayers.append({'rec': downloader, 'segment': item})
                downloader.start()
        self.mainWindow.listSegmentPostiton.update()


class VlcPlayer:

    def __init__(self):
        try:
            os.remove('vlc.log')
        except:
            pass
        self.instance = vlc.Instance("--verbose=2 --network-caching=1000 --no-snapshot-preview --no-osd --file-logging --logfile=vlc.log")
        self.mediaplayer = self.instance.media_player_new()

    def setMedia(self, mediaFile):

        if sys.version < '3':
            filename = unicode(mediaFile)
        else:
            filename = mediaFile

        self.media = self.instance.media_new(filename)
        self.mediaplayer.set_media(self.media)
        self.media.parse()

    def createWidget(self, parent=None):
        self.videoframe = QFrame(parent)
        self.videoPalette = self.videoframe.palette()
        self.videoPalette.setColor(QPalette.Window,
                              QColor(0, 0, 0))
        self.videoframe.setAutoFillBackground(True)
        self.videoframe.setPalette(self.videoPalette)

        if sys.platform.startswith('linux'):
            self.mediaplayer.set_xwindow(self.videoframe.winId())
        elif sys.platform == "win32":
            self.mediaplayer.set_hwnd(self.videoframe.winId())
        elif sys.platform == "darwin":
            self.mediaplayer.set_nsobject(int(self.videoframe.winId()))

        return self.videoframe


class Downloader(threading.Thread):

    def __init__(self, pathUrl, path_to_save):
        super().__init__()
        self.state = False
        self.pathUrl = pathUrl
        self.path_to_save = path_to_save

    def run(self):
        r = requests.get(self.pathUrl, stream=True)
        if r.status_code == 200:
            with open(self.path_to_save, "wb") as f:
                for chunk in r.iter_content(1024):
                    f.write(chunk)
        self.state = True

