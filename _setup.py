import sys, os
from cx_Freeze import setup, Executable


if sys.platform == "win32":
    base = "Win32GUI"
    PYQT5_DIR = "C:/env/Lib/site-packages/PyQt5/Qt"
    include_files = [
        (os.path.join(PYQT5_DIR, "qml", "QtQuick.2"), "QtQuick.2"),
        (os.path.join(PYQT5_DIR, "qml", "QtQuick"), "QtQuick"),
        (os.path.join(PYQT5_DIR, "qml", "QtGraphicalEffects"), "QtGraphicalEffects"),
        "controllers",
        "models",
        "media",
        "views",
        "vlcMedia.py",
        "services.py",
        "config.py",
        "logger.conf",
        "libvlc.dll",
        "vlc.py",
    ]

setup(
    name="exe",
    version="0.9",
    description="asd",
    author="beast",
    author_email="houshao55@gmail.com",
    options={"build_exe": {"packages": ["atexit", "sip","PyQt5.QtCore","PyQt5.QtGui","PyQt5.QtWidgets",
                                    "PyQt5.QtNetwork","PyQt5.QtOpenGL", "PyQt5.QtQml", "PyQt5.QtQuick", "requests", "os", "sys", "idna"],
                       "include_files": include_files,
                       "excludes" : ['Tkinter'],
                       # "optimize" : 2,
                       # "compressed" : True,
                       # "include_msvcr" : True,
                   }},
executables=[
    Executable(script="run.py",
               targetName="AppBuild.exe",
               base=base)
]
)
