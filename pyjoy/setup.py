from distutils.core import setup, Extension

setup(name = "PyJoy",
      version = "1.0",
      ext_modules = [Extension("pyjoy", ["pyjoy.c"])])

