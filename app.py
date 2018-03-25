"""
    App
"""

from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
from controllers.appControls import *
from vlcMedia import *
import os
from controllers import utils
from config import base_dir
from settingsWindow import SettingsWindow
from logsWindow import LogsWindow


class Player(QMainWindow):

    def __init__(self):
        super().__init__()
        self.title = "Precorder Extractor"
        self.tray_icon_path = os.path.join(base_dir, 'views', 'static', 'circle.png')
        self.app_icon_path = os.path.join(base_dir, 'views', 'static', 'circle.png')
        self.width = config.windowWidth
        self.height = config.windowHeight
        self.currentWidth = self.width
        self.currentHeight = self.height
        self.currentCP = QPoint(0, 0)
        self.screenSize = QDesktopWidget().screenGeometry(-1)
        self.current_epg = {}
        self.current_epg_obj = None
        self.custom_epg = False
        self.child_epg = None
        self.child_position = None
        self.updateCurrentPosition = 0
        self.updateOldPosition = 0
        self.vlc_media_buffering_state = False
        self.updateStep = config.updateStep
        self.bufferValue = config.bufferValue
        self.waitingFramePath = config.lastFramePath
        self.timePostitonSecond = 0
        self.listExtractingPlayers = []
        self.listStoringPlayers = []
        self.updateWindowState = False
        self.media_state = False
        self.settingsWindow = SettingsWindow()
        self.logsWindow = LogsWindow()

        self.initLabels()
        self.initVLC()
        self.registerObj()
        self.initUI()

    def initLabels(self):
        self.connectLabel = QLabel()
        self.connectLabel.hide()
        self.connectLabel.setText("Failed to connect in accordance with the settings")
        self.connectLabel.setStyleSheet('color: gray; font-size: 18pt;')
        self.connectLabel.setAlignment(Qt.AlignCenter)

    def initVLC(self):
        self.vlcPlayer = VlcPlayer()
        self.pauseBackFrame = QFrame()
        self.pauseBackLabel = QLabel(self.pauseBackFrame)
        self.playerWidget = self.vlcPlayer.createWidget()
        self.overlay = WaitIndicator(self.pauseBackFrame)

    def initUI(self):
        self.setWindowTitle(self.title)
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.resize(self.width, self.height)
        self.center()
        self.oldPos = self.pos()
        self.setWindowIcon(QIcon(self.app_icon_path))
        self.setAttribute(Qt.WA_NoSystemBackground, True)
        self.setStyleSheet("background: transparent;")

        # self.initSysTray()

        qml_dir = os.path.join(base_dir, 'views')
        self.topElem = QmlContainer(height=40)
        self.setQmlContext(self.topElem, 'WindowControls', self.windowControls)
        self.topElem.quickView.setSource(QUrl('views/topBar.qml'))
        self.topContainer = self.topElem.container

        self.leftElem = QmlContainer(width=250)
        self.setQmlContext(self.leftElem, 'PlayerControls', self.videoControls)
        self.setQmlContext(self.leftElem, 'ListSegmentPostiton', self.listSegmentPostiton)
        self.setQmlContext(self.leftElem, 'FocusState', self.focusState)
        self.setQmlContext(self.leftElem, 'ListChannels', self.listChannels)
        self.setQmlContext(self.leftElem, 'ListEpg', self.listEpg)
        # self.leftElem.quickView.setSource(QUrl(os.path.join(qml_dir, 'leftBar.qml')))
        self.leftElem.quickView.setSource(QUrl('views/leftBar.qml'))
        self.leftContainer = self.leftElem.container

        self.rightElem = QmlContainer(width=250)
        self.setQmlContext(self.rightElem, 'PlayerControls', self.videoControls)
        self.setQmlContext(self.rightElem, 'SelectedEPG', self.selectedEPG)
        self.setQmlContext(self.rightElem, 'CustomEpgControls', self.customEpgControls)
        self.setQmlContext(self.rightElem, 'ListSegmentPostiton', self.listSegmentPostiton)
        self.setQmlContext(self.rightElem, 'ListChannels', self.listChannels)
        # self.rightElem.quickView.setSource(QUrl(os.path.join(qml_dir, 'rightBar.qml')))
        self.rightElem.quickView.setSource(QUrl('views/rightBar.qml'))
        self.rightContainer = self.rightElem.container

        self.middleElem = QmlContainer(height=195)
        self.setQmlContext(self.middleElem, 'VideoTimer', self.playerTimer)
        self.setQmlContext(self.middleElem, 'VideoSlider', self.videoSlider)
        self.setQmlContext(self.middleElem, 'VideoControls', self.videoControls)
        self.setQmlContext(self.middleElem, 'FocusState', self.focusState)
        self.setQmlContext(self.middleElem, 'Status', self.status)
        self.middleElem.quickView.setSource(QUrl('views/middleBar.qml'))
        self.middleContainer = self.middleElem.container

        self.setQmlContext(self.logsWindow, 'AppLogs', self.appLogs)
        self.logsWindow.quickView.setSource(QUrl('views/logs.qml'))
        self.setQmlContext(self.settingsWindow, 'AppSettings', self.appSettings)
        self.settingsWindow.quickView.setSource(QUrl('views/settings.qml'))

        self.widget = QWidget(self)

        self.setCentralWidget(self.widget)

        self.createFrame()

        self.mainGrid = QGridLayout()
        self.content.setLayout(self.mainGrid)
        self.mainGrid.setContentsMargins(0, 0, 0, 0)
        self.mainGrid.setSpacing(0)
        self.mainGrid.addWidget(self.topContainer, 0, 0)

        self.contentGrid = QGridLayout()
        self.contentGrid.setContentsMargins(0, 0, 0, 0)
        self.contentGrid.setSpacing(0)
        self.mainGrid.addLayout(self.contentGrid, 1, 0)

        self.middleGrid = QGridLayout()
        self.middleGrid.setContentsMargins(0, 0, 0, 0)
        self.middleGrid.setSpacing(0)

        self.middleGrid.addWidget(self.playerWidget, 0, 0)
        self.middleGrid.addWidget(self.pauseBackFrame, 0, 0)
        self.middleGrid.addWidget(self.connectLabel, 0, 0)
        self.pauseBackFrame.setVisible(False)

        self.middleGrid.addWidget(self.middleContainer, 1, 0)

        self.contentGrid.addWidget(self.leftContainer, 0, 0)
        self.contentGrid.addLayout(self.middleGrid, 0, 1)
        self.contentGrid.addWidget(self.rightContainer, 0, 2)

        self.timer = QTimer(self)
        self.timer.timeout.connect(self.updateUI)
        self.timer.start(self.updateStep * 1000)

        self.show()

    def center(self):
        qr = self.frameGeometry()
        cp = QDesktopWidget().availableGeometry().center()
        qr.moveCenter(cp)
        self.move(qr.topLeft())
        self.currentCP = qr.topLeft()

    def initSysTray(self):
        show_action = QAction("Show", self)
        quit_action = QAction("Quit", self)
        # show_action_settings = QAction("Settings", self.settingsWindow)
        show_action.triggered.connect(self.show)
        quit_action.triggered.connect(self.close)
        # show_action_settings.triggered.connect(self.settingsWindow.show)
        self.tray_icon = QSystemTrayIcon(self)
        self.tray_icon.setIcon(QIcon(self.tray_icon_path))
        self.tray_icon.activated.connect(self.show)

        tray_menu = QMenu()
        # tray_menu.addAction(show_action_settings)
        tray_menu.addAction(show_action)
        tray_menu.addAction(quit_action)
        self.tray_icon.setContextMenu(tray_menu)
        self.tray_icon.show()

    def registerObj(self):
        self.playerTimer = VideoTimer(mainWindow=self)
        self.videoSlider = VideoSlider(mainWindow=self)
        self.listChannels = ListChannels(self.connectLabel)
        self.listEpg = ListEpg()
        try:
            self.listEpg.setEpg(address=self.listChannels._channels[0]._channel_address)
        except:
            pass
        self.windowControls = WindowControls(self)
        self.videoControls = VideoControls(self)
        self.selectedEPG = SelectedEPG()
        self.listSegmentPostiton = ListSegmentPostiton()
        self.customEpgControls = CustomEpgControls(self)
        self.focusState = FocusState()
        self.status = Status()
        self.appLogs = AppLogs(self.logsWindow)
        self.appSettings = AppSettings(self, self.settingsWindow)

    def setQmlContext(self, elem, name_obj, obj):
        elem.quickView.engine().rootContext().setContextProperty(name_obj, obj)

    def resizeEvent(self, event):
        self.overlay.resize(event.size())
        event.accept()

    def updateUI(self):
        self.videoControls.updateStateVideo()
        self.updateCurrentPosition = self.vlcPlayer.mediaplayer.get_position()
        if (self.updateCurrentPosition == self.updateOldPosition) and self.vlcPlayer.mediaplayer.is_playing():
            self.playerWidget.hide()
            self.pauseBackFrame.show()
            self.vlc_media_buffering_state = True
            # self.vlcPlayer.mediaplayer.video_take_snapshot(0, self.waitingFramePath, 0, 0)
            # self.pauseBackPixmap = QPixmap(self.waitingFramePath)
            # try:
            #     pixmapWidth = self.playerWidget.width()
            #     pixmapHeight = self.playerWidget.width() / (self.vlcPlayer.mediaplayer.video_get_size()[0] / self.vlcPlayer.mediaplayer.video_get_size()[1])
            #     self.pauseBackLabel.setPixmap(self.pauseBackPixmap)
            #     self.pauseBackLabel.setScaledContents(True)
            #     self.pauseBackLabel.setSizePolicy(QSizePolicy.Ignored, QSizePolicy.Ignored)
            #     self.pauseBackLabel.setFixedWidth(self.playerWidget.width())
            #     self.pauseBackLabel.setFixedHeight(self.playerWidget.width() / 1.8)
            #     self.pauseBackLabel.move(0, (self.playerWidget.height() - self.playerWidget.width() / 1.8) / 2)
            # except:
            #     pass
        else:
            utils.getCurPosSeconds(self)
            self.pauseBackFrame.hide()
            self.playerWidget.show()
            self.vlc_media_buffering_state = False
            try:
                self.rel_slider_time = self.videoSlider.videoSliderPosition / self.video_time
            except:
                pass

            if self.vlcPlayer.mediaplayer.is_playing():
                utils.updateTimeSecond(self)

        if self.vlcPlayer.mediaplayer.get_state() == vlc.State.Ended:
            utils.clearVideoFrame(self)
        else:
            self.updateOldPosition = self.updateCurrentPosition
            self.playerTimer.updateTimer()
            self.videoSlider.updateSliderPos()
        for item in self.listExtractingPlayers:
            if item.get('rec').state:
                item.get('segment').changeState(2)
        for item in self.listExtractingPlayers:
            if item.get('segment')._stateDL == 1:
                self.videoControls.changeExtractingState(1)
                break
            else:
                self.videoControls.changeExtractingState(0)

        for item in self.listStoringPlayers:
            if item.get('rec').state:
                item.get('segment').changeStateStore(2)
        for item in self.listStoringPlayers:
            if item.get('segment')._stateST == 1:
                self.videoControls.changeStoringState(1)
                break
            else:
                self.videoControls.changeStoringState(0)

        self.appLogs.updateLogs()

    def createFrame(self):
        edgeHeight = 3
        edgeWidth = 3
        self.wrapGrid = QVBoxLayout(self.widget)
        self.wrapGrid.setContentsMargins(0, 0, 0, 0)
        self.wrapGrid.setSpacing(0)

        self.topResizeGrid = QHBoxLayout()
        self.topResizeGrid.setContentsMargins(0, 0, 0, 0)
        self.topResizeGrid.setSpacing(0)

        self.middleResizeGrid = QHBoxLayout()
        self.middleResizeGrid.setContentsMargins(0, 0, 0, 0)
        self.middleResizeGrid.setSpacing(0)

        self.botResizeGrid = QHBoxLayout()
        self.botResizeGrid.setContentsMargins(0, 0, 0, 0)
        self.botResizeGrid.setSpacing(0)

        self.topAnch = AnchorBut('', mainWindow=self, flagY=True, activeY=True)
        self.topAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.topAnch.setFixedHeight(edgeHeight)
        self.topAnch.setCursor(Qt.SizeVerCursor)

        self.topLeftAnch = AnchorBut('', mainWindow=self, flagX=True, flagY=True, activeX=True, activeY=True)
        self.topLeftAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.topLeftAnch.setFixedSize(edgeWidth, edgeHeight)
        self.topLeftAnch.setCursor(Qt.SizeFDiagCursor)

        self.topRightAnch = AnchorBut('', mainWindow=self, flagX=True, flagY=True, activeY=True)
        self.topRightAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.topRightAnch.setFixedSize(edgeWidth, edgeHeight)
        self.topRightAnch.setCursor(Qt.SizeBDiagCursor)

        self.botAnch = AnchorBut('', mainWindow=self, flagY=True)
        self.botAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.botAnch.setFixedHeight(edgeHeight)
        self.botAnch.setCursor(Qt.SizeVerCursor)

        self.botLeftAnch = AnchorBut('', mainWindow=self, flagX=True, flagY=True, activeX=True)
        self.botLeftAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.botLeftAnch.setFixedSize(edgeWidth, edgeHeight)
        self.botLeftAnch.setCursor(Qt.SizeBDiagCursor)

        self.botRightAnch = AnchorBut('', mainWindow=self, flagX=True, flagY=True)
        self.botRightAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.botRightAnch.setFixedSize(edgeWidth, edgeHeight)
        self.botRightAnch.setCursor(Qt.SizeFDiagCursor)

        self.middleLeftAnch = AnchorBut('', mainWindow=self, flagX=True, activeX=True)
        self.middleLeftAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.middleLeftAnch.setFixedWidth(edgeWidth)
        self.middleLeftAnch.setSizePolicy(QSizePolicy.Preferred, QSizePolicy.Expanding)
        self.middleLeftAnch.setCursor(Qt.SizeHorCursor)

        self.middleRightAnch = AnchorBut('', mainWindow=self, flagX=True)
        self.middleRightAnch.setStyleSheet("background-color: #1f1b28; border: none;")
        self.middleRightAnch.setFixedWidth(edgeWidth)
        self.middleRightAnch.setSizePolicy(QSizePolicy.Preferred, QSizePolicy.Expanding)
        self.middleRightAnch.setCursor(Qt.SizeHorCursor)

        self.content = QFrame()
        self.content.setStyleSheet("background-color: transparent; border: none")

        self.topResizeGrid.addWidget(self.topLeftAnch, 0)
        self.topResizeGrid.addWidget(self.topAnch, 1)
        self.topResizeGrid.addWidget(self.topRightAnch, 2)

        self.botResizeGrid.addWidget(self.botLeftAnch, 0)
        self.botResizeGrid.addWidget(self.botAnch, 1)
        self.botResizeGrid.addWidget(self.botRightAnch, 2)

        self.middleResizeGrid.addWidget(self.middleLeftAnch, 0)
        self.middleResizeGrid.addWidget(self.content, 1)
        self.middleResizeGrid.addWidget(self.middleRightAnch, 2)

        self.wrapGrid.addLayout(self.topResizeGrid, 0)
        self.wrapGrid.addLayout(self.middleResizeGrid, 1)
        self.wrapGrid.addLayout(self.botResizeGrid, 2)

    def updateWindow(self):
        if self.updateWindowState:
            self.resize(self.frameGeometry().width() + 1, self.frameGeometry().height())
        else:
            self.resize(self.frameGeometry().width() - 1, self.frameGeometry().height())
        self.updateWindowState = not self.updateWindowState


class AnchorBut(QPushButton):
    def __init__(self, title, parent=None, mainWindow=None, flagX=False, flagY=False, activeX=False, activeY=False):
        super().__init__(title, parent)
        self.mainWindow = mainWindow
        self.setAcceptDrops(True)
        self.oldPos = None
        self.oldCurPosX = None
        self.oldCurPosY = None
        self.flagX = flagX
        self.flagY = flagY
        self.activeX = activeX
        self.activeY = activeY

    def mouseMoveEvent(self, e):
        self.oldPos = self.mainWindow.pos()
        self.newX = self.oldPos.x()
        self.newY = self.oldPos.y()

        if e.buttons() != Qt.RightButton:
            if self.flagX and not self.activeX:
                width = self.mainWindow.frameGeometry().width() - (self.oldCurPosX - e.x())
            elif self.flagX and self.activeX:
                width = self.mainWindow.frameGeometry().width() + (self.oldCurPosX - e.x())
                if width > self.mainWindow.width:
                    self.newX = self.oldPos.x() - (self.oldCurPosX - e.x())
            else:
                width = self.mainWindow.frameGeometry().width()

            if self.flagY and not self.activeY:
                height = self.mainWindow.frameGeometry().height() - (self.oldCurPosY - e.y())
            elif self.flagY and self.activeY:
                height = self.mainWindow.frameGeometry().height() + (self.oldCurPosY - e.y())
                if height > self.mainWindow.height:
                    self.newY = self.oldPos.y() - (self.oldCurPosY - e.y())
            else:
                height = self.mainWindow.frameGeometry().height()

            cp = QPoint(self.newX, self.newY)
            self.mainWindow.move(cp)
            self.mainWindow.currentCP = cp
            if width < self.mainWindow.width:
                width = self.mainWindow.width
            if height < self.mainWindow.height:
                height = self.mainWindow.height
            self.mainWindow.resize(width, height)
            self.mainWindow.currentWidth = width
            self.mainWindow.currentHeight = height

    def mousePressEvent(self, e):

        QPushButton.mousePressEvent(self, e)

        if e.button() == Qt.LeftButton:
            self.oldCurPosY = e.y()
            self.oldCurPosX = e.x()


class QmlContainer:

    def __init__(self, width=None, height=None):
        self.quickView = QQuickView()
        self.quickView.setResizeMode(QQuickView.SizeRootObjectToView)
        self.container = QWidget.createWindowContainer(self.quickView)
        self.container.setStyleSheet('background: black;')

        if width is not None:
            self.container.setFixedWidth(width)
        if height is not None:
            self.container.setFixedHeight(height)

