import sys
from PyQt5.QtWidgets import QApplication
from app import Player
import logging.config
import logging
import os


def run():
    try:
        os.remove('app.log')
    except:
        pass

    logging.config.fileConfig('logger.conf')
    logger = logging.getLogger("app")

    logger.info("Program started")

    sys_argv = sys.argv
    sys_argv += ['--style', 'universal']
    app = QApplication(sys_argv)

    player = Player()

    app.exec_()
    logger.info("exit")
    sys.exit()


if __name__ == '__main__':
    run()
