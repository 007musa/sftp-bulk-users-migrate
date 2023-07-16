import logging

formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s', '%Y-%m-%d-%H:%M:%S')

def getLogger(name, log_file, level=logging.DEBUG):

    fileHandler = logging.FileHandler(log_file)
    fileHandler.setFormatter(formatter)

    consoleHandler = logging.StreamHandler()
    consoleHandler.setFormatter(formatter)

    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.addHandler(fileHandler)
    logger.addHandler(consoleHandler)

    return logger