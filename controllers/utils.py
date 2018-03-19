import datetime
import time
import os
import config


def getDurationSeconds(mainWindow):
    current_epg = mainWindow.current_epg_obj
    if current_epg is not None:
        startTime = convertToTimestamp(current_epg.startTime, current_epg.date)
        endTime = convertToTimestamp(current_epg.endTime, current_epg.date)
        return endTime - startTime
    else:
        return 0


def getCurPosSeconds(mainWindow):
    curPosition = mainWindow.vlcPlayer.mediaplayer.get_position()
    current_epg = mainWindow.current_epg_obj
    if current_epg is not None:
        duration = getDurationSeconds(mainWindow)
        return duration * curPosition
    else:
        return 0


def convertToTimestamp(inputTime, inputDate):
    dateTimeStr = '{};{}'.format(inputTime, inputDate)
    dateTime = datetime.datetime.strptime(dateTimeStr, "%H:%M:%S;%d.%m.%Y")
    timesTamp = int(time.mktime(dateTime.timetuple()))
    return timesTamp


def updateTimeSecond(mainWindow):
    duration = getDurationSeconds(mainWindow)
    mainWindow.timePostitonSecond += mainWindow.updateStep + (mainWindow.bufferValue / 1000 / (duration - 1) * mainWindow.updateStep)


def stopTimeSecond(timePosition):
    timePosition = 0


def timeInt2Str(current_time):
    absHours = current_time // 3600000
    absMinutes = current_time // 60000
    absSeconds = current_time // 1000
    hours = absHours
    if int(absMinutes) < 60:
        minutes = str(int(absMinutes))
    else:
        minutes = str(int(absMinutes % 60))

    if int(absSeconds) < 60:
        seconds = str(int(absSeconds))
    else:
        seconds = str(int(absSeconds % 60))

    if int(hours) < 10:
        hours = "0" + str(int(hours))

    if int(minutes) < 10:
        minutes = "0" + str(int(minutes))

    if int(seconds) < 10:
        seconds = "0" + str(int(seconds))

    return hours + ":" + minutes + ":" + seconds


def clearWaitingFrame():
    try:
        os.remove(config.lastFramePath)
    except:
        pass


def setVideoPos(mainWindow,
                sliderPosition=None,
                shiftValue=None, shiftDir=None):

    if sliderPosition is not None and shiftValue is None and shiftDir is None:
        changePosVideo(mainWindow, sliderPosition)

    if sliderPosition is None and shiftValue is not None and shiftDir is not None:
        normalShiftValue = shiftValue / 1000
        duration_seconds = getDurationSeconds(mainWindow)
        if shiftDir == '+':
            # mainWindow.videoSlider.videoSliderPosition = 1000 / duration_seconds * (mainWindow.timePostitonSecond + normalShiftValue)
            sliderPosition = 1000 / duration_seconds * (mainWindow.timePostitonSecond + normalShiftValue)
            changePosVideo(mainWindow, sliderPosition)
        else:
            sliderPosition = 1000 / duration_seconds * (mainWindow.timePostitonSecond - normalShiftValue)
            changePosVideo(mainWindow, sliderPosition)

def changePosVideo(mainWindow, sliderPosition):
    duration_video_second = getDurationSeconds(mainWindow)
    per_slider_position = sliderPosition / 1000
    child_start_pos = int(duration_video_second * per_slider_position)
    mainWindow.timePostitonSecond = child_start_pos
    childSliderPositionStart = sliderPosition
    mainWindow.vlcPlayer.mediaplayer.pause()
    cur_epg = mainWindow.current_epg
    child_epg = {'startTimesTamp': cur_epg.get('startTimesTamp') + child_start_pos,
                 'endTimesTamp': cur_epg.get('endTimesTamp'),
                 'recorder': cur_epg.get('recorder')}
    mainWindow.child_epg = child_epg
    epg_url = '{0}{1}.record?from={2}&to={3}'.format(config.mediahost, child_epg.get('recorder'),
                                                     str(child_epg.get('startTimesTamp')),
                                                     str(child_epg.get('endTimesTamp')))
    mainWindow.vlcPlayer.mediaplayer.pause()
    mainWindow.vlcPlayer.setMedia(epg_url)
    mainWindow.vlcPlayer.mediaplayer.play()


def clearVideoFrame(mainWindow):
    try:
        mainWindow.vlcPlayer.mediaplayer.stop()
        mainWindow.vlcPlayer.mediaplayer.set_position(0)
    except:
        pass
    mainWindow.timePostitonSecond = 0
    mainWindow.pauseBackFrame.hide()
    mainWindow.playerWidget.show()
    try:
        mainWindow.vlcPlayer.setMedia(mainWindow.current_epg.get('url'))
    except:
        pass
    mainWindow.updateWindow()