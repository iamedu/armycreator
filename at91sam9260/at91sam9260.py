#!/bin/env python

import threading
import time
import sys
import ConfigParser
from PyQt4 import QtGui
from PyQt4 import QtCore
from PyQt4.QtCore import Qt

class Uart(QtGui.QWidget):
    size = 1

    byteWritten = QtCore.pyqtSignal(int)

    def __init__(self, name, base, memory, conf, core, parent=None):
	QtGui.QWidget.__init__(self, parent)

        self.conf = conf
	self.base = base
	self.memory = memory


	self.setWindowTitle("UART: " + name)
	self.setToolTip("This is a UART device connected to armyc")

        self.text = QtGui.QTextEdit(self)
	self.text.resize(650, 350)
	self.text.setReadOnly(True)

	self.byteWritten.connect(self.updateUart, Qt.BlockingQueuedConnection)

	self.show()

    @QtCore.pyqtSlot(int)
    def updateUart(self, value):
	scrollbar = self.text.verticalScrollBar()
        self.text.insertPlainText(chr(value))
	scrollbar.setValue(scrollbar.maximum())
	self.show()

    def writeByte(self, address, value):
	self.byteWritten.emit(value)
	self.memory.writeByte(0, 0)

    def readByte(self, address):
	pass

class Control(object):
    size = 1
    def __init__ ( self, name, base, memory, conf, core) :
        from pyjoy import Controller
	self.memory = memory
        self.port = conf[name]["port"]
        self.c = Controller(self.port)
	self.core = core
	self.active = True
        self.t = threading.Thread(target=self.mov)
        self.t.start()

    def writeByte(self, address, value):
        pass

    def mov(self):
        while self.active:
            t = self.c.buttons()
	    ta = self.c.axes()
            #arriba, derecha, abajo, izquierda
	    dir = [0, 0, 0, 0]
            if t[4] == 1 or (ta[1] >= -32767 and ta[1] < 0):
	        dir[0] = 1
            if t[6] == 1 or (ta[1] > 0 and ta[1] <= 32767):
	        dir[2] = 1
            if t[5] == 1 or (ta[0] > 0 and ta[0] <= 32767):
	        dir[1] = 1
            if t[7] == 1 or (ta[0] >= -32767 and ta[0] < 0):
	        dir[3] = 1

	    if dir[0] and dir[1]:
	        result = 1
            elif dir[1] and dir[2]:
	    	result = 3
	    elif dir[2] and dir[3]:
	        result = 5
	    elif dir[3] and dir[0]:
	        result = 7
	    elif dir[0]:
	        result = 0
	    elif dir[1]:
	        result = 2
	    elif dir[2]:
	        result = 4
	    elif dir[3]:
	        result = 6
	    else:
	        result = -1
            self.memory.writeByte(0,result)
            time.sleep(0.05)

    def __del__(self):
        self.active = False

class LcdMx( QtGui.QWidget ):
    size=24
    move = QtCore.pyqtSignal()

    def __init__(self, name, base, memory, conf, core, parent=None):
        QtGui.QWidget.__init__ ( self, parent )

	self.conf = conf
	self.base = base
	self.memory = memory

        self.setWindowTitle("LCD")
        self.setToolTip("This is a LCD device connected to armyc")
        self.resize(320, 240)

	self.scene = QtGui.QGraphicsScene ()
	self.scene.setSceneRect(0, 0, 320, 240)
	self.view = QtGui.QGraphicsView(self.scene, self)
	self.view.show()
	self.c = ConfigParser.ConfigParser()
	self.action = 0
	self.width = 0
	self.height = 0
	self.id = ""
	self.id_d = 0
	self.id_t = 0
	self.x = 0
	self.y = 0
	self.l = {}
	self.count = 1
	self.c.read([conf[name]["config"]])

        for i in range(6):
            self.memory.writeByte(i, 0)

        self.move.connect(self.actions, Qt.BlockingQueuedConnection)

	self.show()

    def readReg(self, address):
        return self.memory.readByte(address)

    def writeReg(self, address, value):
        self.memory.writeByte(address, value)

    def writeByte(self, address, value):
        if address == 3:
    	    self.move.emit()

    def readData(self, reg):
        import struct
        index = reg * 4
        finish = index + 4
        data = ""
        for i in range(index, finish):
            data += chr(self.readReg(i) & 0xff)
        result = struct.unpack("I", data)
        return result[0]


    def writeRes(self, res1, res2):
        import struct
        num1 = struct.pack("I", res1)
        num2 = struct.pack("I", res2)
        for i in range(16, 20):
            self.writeReg(i, ord(num1[i - 16]))
        for i in range(20, 24):
            self.writeReg(i, ord(num2[i - 20]))

    @QtCore.pyqtSlot()
    def actions(self):
        action = self.readData(0)
        if action == 1:
            x = self.readData(1)
	    y = self.readData(2)
	    id = self.readData(3)

            img = QtGui.QPixmap(str(self.c.get("images", str(id))))
            object = QtGui.QGraphicsPixmapItem(img)
	    object.setPos(x, y)
	    self.scene.addItem(object);
	    tl = QtCore.QTimeLine ( 4 )
	    tl.setFrameRange ( 0 , 3 )
	    a = QtGui.QGraphicsItemAnimation ( )
	    a.setItem ( object )
	    a.setTimeLine ( tl )

	    self.l[self.count] = [x, y, img.width(), img.height(), a]
            self.writeRes(self.count, 0)
            print "id", self.count
	    self.count += 1
	elif action == 2:
            id = self.readData(1) 
	    id_d = self.readData(2) 
	    id_t = self.readData(3) 
            x = self.l[id][0]
	    y = self.l[id][1]
	    a = self.l[id][4]
            tl = a.timeLine()
 
	    if tl.state() == 0:
	        a.clear()
	        i = 0
	        while i < 4:
	            a.setPosAt ( i/4, QtCore.QPointF ( x, y ) )
		    i += 1
		    if id_d == 0:
		        y -= 1
		    elif id_d == 1:
		        y -= 1
		        x += 1
		    elif id_d == 2:
	                x += 1
		    elif id_d == 3:
	                x += 1
	                y += 1
		    elif id_d == 4:
	                y += 1
		    elif id_d == 5:
                        x -= 1
	                y += 1
		    elif id_d == 6:
                        x -= 1
		    elif id_d == 7:
                        x -= 1
		        y -= 1
                self.l[id][0] = x
	        self.l[id][1] = y
	        tl.start( )
	elif action == 3:
	    id = self.readData(1)
            self.writeRes(self.l[id][0], self.l[id][1])
	elif action == 4:
	    id = self.readData(1)
	    x = self.readData(2)
	    y = self.readData(3)
	    a = self.l[id][4]
	    tl = a.timeLine()
	    a.clear()
	    a.setPosAt(1, QtCore.QPointF( x, y))
	    self.l[id][0] = x
	    self.l[id][1] = y
	    tl.start()
	elif action == 5:
	    id = self.readData(1)
	    self.writeRes(self.l[id][2], self.l[id][3])
