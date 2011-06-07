from PyQt4 import QtGui, QtCore
from PyQt4.QtCore import Qt
import ConfigParser

class LcdMx( QtGui.QWidget ):

    create_obj = QtCore.pyqtSignal(int,int,int,int)
    move_obj = QtCore.pyqtSignal(int,int,int)
    setposition_xy = QtCore.pyqtSignal(int,int,int)

    def __init__(self, parent=None):
        QtGui.QWidget.__init__ ( self, parent )

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
	self.c.read("images.cfg")

	self.create_obj.connect(self.create)
	self.move_obj.connect(self.move)
	self.setposition_xy.connect(self.setposition)

    @QtCore.pyqtSlot(int,int,int,int)
    def create(self, x, y, id_obj, id_created):
	id = id_obj
	img = QtGui.QPixmap(str(self.c.get("images", str(id))))
        object = QtGui.QGraphicsPixmapItem(img)
        object.setPos(x, y)
        self.scene.addItem(object)
	tl = QtCore.QTimeLine ( 4 )
	tl.setFrameRange ( 0 , 3 )
	a = QtGui.QGraphicsItemAnimation ( )
	a.setItem ( object )
	a.setTimeLine ( tl )

	self.l[id_created] = [x, y, img.width(), img.height(), a]

    def create_object(self, x, y, id_obj):
        res = self.count
	self.count += 1
	self.create_obj.emit(x, y, id_obj, res)
	return res

    @QtCore.pyqtSlot(int,int, int)
    def move(self, id_obj, d, t):
        id = id_obj
	id_d = d
	id_t = t
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

    @QtCore.pyqtSlot(int,int, int)
    def setposition(self, id_obj, x, y):
        id = id_obj
	a = self.l[id][4]
	tl = a.timeLine()
        a.clear()
	a.setPosAt(1, QtCore.QPointF( x, y))
	self.l[id][0] = x
	self.l[id][1] = y
	tl.start()

    def position(self, id_obj):
        id = id_obj
	pos = [self.l[id][0], self.l[id][1]]
	return pos

    def dimensions(self, id_obj):
        id = id_obj
	pos = [self.l[id][2], self.l[id][3]]
	return pos
