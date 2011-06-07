import socket
import lcd
import sys
import threading
from PyQt4 import QtGui

def parseOp(data):
    opparams = [ord(data[i]) for i in range(4)]
    return tuple(opparams)

def parseRes(reg1, reg2):
    return "%c%c" % (reg1, reg2)

def main():
    app = QtGui.QApplication(sys.argv)
    Lcd = lcd.LcdMx()
    Lcd.show()

    t = threading.Thread(target=principal(Lcd))
    t.start()

    sys.exit(app.exec_())

def principal(Lcd):
    s = socket.socket()
    s.bind(("", 1234))
    s.listen(1)

    sc, addr = s.accept()

    #while True:
        data = sc.recv(4);
        if len(data) > 0:
            data = parseOp(data)
            if data[0] == 1:
    	        id = Lcd.create_obj.emit(data[1], data[2, data[3]])
                sc.send(parseRes(id, 0))
     	    elif data[0] == 2:
    	        Lcd.move_obj.emit(data[1], data[2], data[3])
    	    elif data[0] == 3:
    	        pos = Lcd.position_obj.emit(data[1])
                sc.send(parseRes(pos[0], pos[1]))
        else:
            break
    sc.close()
    s.close()

if __name__ == "__main__":
    main()
