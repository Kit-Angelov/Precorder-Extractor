from PyQt5.QtWidgets import QHBoxLayout, QPushButton, QSizePolicy
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import QUrl, QPoint
from PyQt5.QtQml import QQmlApplicationEngine
from vlcMedia import *
import os


class SettingsWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.width = 300
        self.height = 200
        self.quickView = QQuickView()
        self.quickView.setResizeMode(QQuickView.SizeRootObjectToView)
        self.container = QWidget.createWindowContainer(self.quickView)
        self.container.setStyleSheet('background: black;')
        self.container.setFixedWidth(self.width)
        self.container.setFixedHeight(self.height)
        self.quickView.setSource(QUrl('views/settings.qml'))
        self.contentGrid = QGridLayout(self)
        self.contentGrid.setSpacing(0)
        self.contentGrid.setContentsMargins(0, 0, 0, 0)
        self.contentGrid.addWidget(self.container, 0, 0)
        self.screenSize = QDesktopWidget().screenGeometry(-1)
        self.move(QPoint(self.screenSize.width() - 100 - self.width, self.screenSize.height() - 50 - self.height))





