#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import os.path
import sys
import subprocess

maxLength = 40
maxLengthUsed = 5
shortenChar = '…'
separator = '|'
longShortenChar = '~'
highlightFormat = "\033[7m"  # invers, bold: "\033[1m"
backtonormFormat = "\033[0m"
sessionDir = ''


def ppid(pid):
    f = open('/proc/{0}/stat'.format(str(pid)), 'r')
    return int(f.read().split()[3])


def pidname(pid):
    f = open('/proc/{0}/stat'.format(str(pid)), 'r')
    return f.read().split()[1][1:-1]


def cmdline(pid):
    f = open('/proc/{0}/cmdline'.format(str(pid)), 'r')
    return f.read().split('\000')[1:-1]


def sessionFileFromCallParameters(parameters):
    returnNext = False
    for parameter in parameters:
        if returnNext:
            return parameter
        if parameter in ['-c', '-A']:
            returnNext = True
    return None


def highlight(string):
    return highlightFormat + string + backtonormFormat


def printReady(sessions, attachedTo):
    # standard
    if maxLength >= len(separator.join(sessions)):
        return printSessions(sessions, attachedTo)

    # shorten items
    maxLengthUnused = max([len(s) for s in sessions if s != sessions[attachedTo]]) - 1
    while maxLengthUnused >= 3:
        sessions = [s[:maxLengthUnused] if s != sessions[attachedTo] else s for s in sessions]
        maxLengthUnused -= 1
        if len(separator.join(sessions)) <= maxLength:
            return printSessions(sessions, attachedTo)
    maxLengthUnused = 1
    sessions = [s[:maxLengthUnused] if s != sessions[attachedTo] else s for s in sessions]
    if len(separator.join(sessions)) <= maxLength:
        return printSessions(sessions, attachedTo)

    # shorten used
    sessions[attachedTo] = sessions[attachedTo][:2+maxLengthUsed]
    if maxLength >= len(separator.join(sessions)):
        return printSessions(sessions, attachedTo)

    return highlight(sessions[attachedTo])


def printSessions(sessions, attachedTo):
    sessions[attachedTo] = highlight(sessions[attachedTo])
    total = sessions[0]
    switch = True
    for session in sessions[1:]:
        if switch:
            switch = False
            total += '\033[2m'
        else:
            switch = True
            total += '\033[0m'
        total += session
    return total
    return separator.join(sessions)


def runningSession():
    pid = os.getpid()
    while pid > 1:
        pid = ppid(pid)
        if pidname(pid) == 'dtach':
            return os.path.basename(sessionFileFromCallParameters(cmdline(pid)))
    return None


def printStatus():
    sessions = os.listdir(sessionDir)
    sessions.sort(key=lambda x: os.stat(sessionDir + x).st_ctime)

    attachedTo = sessions.index(runningSession())
    print printReady(['0:Neu'] + ['{0}:{1}'.format(i+1, session) for (i, session) in enumerate(sessions)], attachedTo+1)


def attach(name):
    subprocess.call(['dtach', '-c', sessionDir + name, 'zsh'])


def rename():
    a = sys.stdin
    print a
    b = a.readline()
    newName = b[:-1].replace('/', '-').replace('\\', '-')
    # newName = sys.stdin.readline()[:-1].replace('/', '-').replace('\\', '-')
    oldName = runningSession()
    if oldName is not None:
        os.rename(sessionDir + runningSession(), sessionDir + newName)
    else:
        attach(newName)
    return True


def start():
    print 'start'


def main():
    switch = {
        'rename': rename,
        'start': start
    }
    if len(sys.argv) > 1 and sys.argv[1] in switch:
        switch[sys.argv[1]]()
    else:
        printStatus()

sessionDir = os.path.dirname(os.path.abspath(__file__)) + '/sessions/'
main()
