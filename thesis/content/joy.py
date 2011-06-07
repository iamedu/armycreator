from pyjoy import Controller

c = Controller("/dev/input/js0")
while True:
    print c.buttons()
    print c.axes()

