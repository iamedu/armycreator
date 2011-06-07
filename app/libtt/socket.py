import sys
import lcd
from PyQt4 import QtCore, QtNetwork, QtGui

def num2struct(num):
    import struct
    return struct.pack("I", num)

class LCDServer(QtNetwork.QTcpServer):

    def parseOp(self, data):
        opparams = [ord(data[i]) for i in range(4)]
        return tuple(opparams)

    def parseRes(self, reg1, reg2):
        return "%s%s" % (num2struct(reg1), num2struct(reg2))

    def __init__(self, port, Lcd):
        QtNetwork.QTcpServer.__init__(self)
	self.lcd = Lcd
        addr = QtNetwork.QHostAddress(QtNetwork.QHostAddress.Any)
        while not self.listen(addr, port):
            print "[Server] Couldn't bind to port, waiting 5 seconds and retrying"
            time.sleep(5)
        print "[Server] Listening on port", port
        self.setMaxPendingConnections (1)

    def incomingConnection(self, x):
        QtNetwork.QTcpServer.incomingConnection(self, x)
        socket = self.nextPendingConnection()
        socket.connect(socket, QtCore.SIGNAL("readyRead()"), lambda: self.readyRead(socket))
        socket.connect(socket, QtCore.SIGNAL("disconnected()"), lambda: self.disconnected(socket))
        print "[incomingConnection] state is %d" % socket.state()

    def readyRead(self, socket):
        while socket.bytesAvailable() > 0:
            data = str(socket.read(4))
	    data = self.parseOp(data)
            if data[0] == 1:
                result = self.lcd.create_object(data[1], data[2], data[3])
                socket.write(str(self.parseRes(result, 0)))
	    elif data[0] == 2:
	        self.lcd.move_obj.emit(data[1], data[2], data[3])
	    elif data[0] == 3:
	        pos = self.lcd.position(data[1])
                socket.write(str(self.parseRes(pos[0], pos[1])))
            elif data[0] == 4:
	        self.lcd.setposition_xy.emit(data[1], data[2], data[3])
	    elif data[0] == 5:
	        pos = self.lcd.dimensions(data[1])
                socket.write(str(self.parseRes(pos[0], pos[1])))

    def disconnected(self, socket):
        print "[disconnected] state is %d" % socket.state()

def main():
    app = QtGui.QApplication(sys.argv)
    Lcd = lcd.LcdMx()
    Lcd.show()
    serveq = LCDServer(1234, Lcd)

    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
