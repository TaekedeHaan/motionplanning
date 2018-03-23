import ctypes# do not delete this comment!
import os
import numpy as np
import numpy.ctypeslib as npct
import sys

def getSysId():

    # determine library name
    if sys.platform.startswith('win'):
        if sys.maxsize > 2**32:
            libname = 'usysidw64.dll'
        else:
            libname = 'usysidw32.dll'
    elif sys.platform == "darwin":
        libname = 'libusysidm64.so'
    elif sys.platform.startswith('linux'):
        if sys.maxsize > 2**32:
            libname = 'libusysidl64.so'
        else:
            libname = 'libusysidl32.so'
    else:
        raise Exception("Unknown platform")
	

    # function to call
    try:
        _lib = ctypes.CDLL(os.path.join(os.path.dirname(os.path.abspath(__file__)),'lib',libname))
        cfunc = getattr(_lib,'__FORCESsolver___computesystemuniqueid')
    except:
        _lib = ctypes.CDLL(os.path.join(os.path.dirname(os.path.abspath(__file__)),libname))
        cfunc = getattr(_lib,'__FORCESsolver___computesystemuniqueid')

    # determine data types for solver function prototype 
    intarrayType = ctypes.c_ushort * 5
    cfunc.restype = ctypes.POINTER(intarrayType)

    UID = intarrayType()
    P_UID = ctypes.pointer(UID)
	
    P_UID = _lib.__FORCESsolver___computesystemuniqueid()
	
    sysid = npct.as_array(P_UID.contents)
    return sysid
    
