#! /usr/bin/python3

import csv
import subprocess
import sys
import time

from loger import *

# Create Log Files
users_file = timestr = time.strftime("users-%Y-%m-%d-%H%M%S.log")
error_file = timestr = time.strftime("errors-%Y-%m-%d-%H%M%S.log")

# Assign levels to files
users_logger = getLogger('users_logger', users_file)
error_logger = getLogger('error_logger', error_file)


def fileHandler():
    try:
        with open('migration-shortcodes.csv', mode='r') as csv_file:
            csv_reader = csv.DictReader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    users_logger.debug('Column names are %s' %(", ".join(row)))
                    line_count += 1
                users_logger.debug('\t [line %s]. SPID %s' % (line_count, row["SPID"]))
                sftpHandler(row["SPID"])
                line_count += 1
            error_logger.debug('\t Processed %s lines.' % (line_count))
    except OSError as fe:
        error_logger.error('File named sftp-users-migration.csv not found: %s' %fe)
    except Exception as e:
        error_logger.error('Error in opening file: %s' %e)
    finally:
        users_logger.debug('Exit script.')


def sftpHandler(username):
    try:
        print(username,username)
        subprocess.check_call(['./del_user.sh', username],\
                                    stdout=sys.stdout, stderr=sys.stderr)
    except Exception as e:
        error_logger.error('Error in deleting user: %s: %s'%(username, e))


fileHandler()