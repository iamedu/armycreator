#!/bin/env python
from armyc import core
from armyc import events
from threading import Thread

import code
import readline
import atexit
import os

banner = """ARMyc Interpreter
This is a program
"""


class ArmycConsole(code.InteractiveConsole):
    def __init__(self, locals=None, filename="<console>",
                 histfile=os.path.expanduser("~/.armyc_history")):
        code.InteractiveConsole.__init__(self, locals, filename)
	self.init_history(histfile)

    def init_history(self, histfile):
        readline.parse_and_bind("tab: complete")
	if hasattr(readline, "read_history_file"):
	    try:
	        readline.read_history_file(histfile)
	    except:
	        pass
	    atexit.register(self.save_history, histfile)

    def save_history(self, histfile):
        import readline
        readline.write_history_file(histfile)



class ArmycThread(Thread):
    def run(self):
        locals = {'core':core}
        console = ArmycConsole(locals)
	console.interact(banner)

th = ArmycThread()

class EventsThread(Thread):
    def run(self):
        while th.isAlive():
	    if events.hasEvents():
                events.executeAll()

def writeLog(line):
    f = open("ellog", "a")
    f.write(line + "\n")
    f.close()


ev = EventsThread()


def start():
    th.start()
    ev.start()

def loop():
    while th.isAlive():
        pass
    
