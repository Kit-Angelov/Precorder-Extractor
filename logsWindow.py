from PyQt5.QtWidgets import QHBoxLayout, QPushButton, QSizePolicy
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import QUrl, QPoint
from PyQt5.QtQml import QQmlApplicationEngine
from vlcMedia import *
import os


class LogsWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.width = 400
        self.height = 600
        self.resize(self.width, self.height)
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.quickView = QQuickView()
        self.quickView.setResizeMode(QQuickView.SizeRootObjectToView)
        self.container = QWidget.createWindowContainer(self.quickView)
        self.container.setStyleSheet('background: black;')
        self.contentGrid = QGridLayout(self)
        self.contentGrid.setSpacing(0)
        self.contentGrid.setContentsMargins(0, 0, 0, 0)
        self.contentGrid.addWidget(self.container, 0, 0)
        self.screenSize = QDesktopWidget().screenGeometry(-1)
        self.startCP = QPoint(self.screenSize.width() - 100 - self.width, self.screenSize.height() - 50 - self.height)
        self.move(self.startCP)





