#FORCESNLPsolver : A fast customized optimization solver.
#
#Copyright (C) 2013-2018 EMBOTECH AG [info@embotech.com]. All rights reserved.
#
#
#This software is intended for simulation and testing purposes only. 
#Use of this software for any commercial purpose is prohibited.
#
#This program is distributed in the hope that it will be useful.
#EMBOTECH makes NO WARRANTIES with respect to the use of the software 
#without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
#PARTICULAR PURPOSE. 
#
#EMBOTECH shall not have any liability for any damage arising from the use
#of the software.
#
#This Agreement shall exclusively be governed by and interpreted in 
#accordance with the laws of Switzerland, excluding its principles
#of conflict of laws. The Courts of Zurich-City shall have exclusive 
#jurisdiction in case of any dispute.
#
#def __init__():
'''
a Python wrapper for a fast solver generated by FORCES Pro v1.6.121

   OUTPUT = FORCESNLPsolver_py.FORCESNLPsolver_solve(PARAMS) solves a multistage problem
   subject to the parameters supplied in the following dictionary:
       PARAMS['x0'] - column vector of length 600
       PARAMS['xinit'] - column vector of length 4
       PARAMS['xfinal'] - column vector of length 2

   OUTPUT returns the values of the last iteration of the solver where
       OUTPUT['x001'] - column vector of size 6
       OUTPUT['x002'] - column vector of size 6
       OUTPUT['x003'] - column vector of size 6
       OUTPUT['x004'] - column vector of size 6
       OUTPUT['x005'] - column vector of size 6
       OUTPUT['x006'] - column vector of size 6
       OUTPUT['x007'] - column vector of size 6
       OUTPUT['x008'] - column vector of size 6
       OUTPUT['x009'] - column vector of size 6
       OUTPUT['x010'] - column vector of size 6
       OUTPUT['x011'] - column vector of size 6
       OUTPUT['x012'] - column vector of size 6
       OUTPUT['x013'] - column vector of size 6
       OUTPUT['x014'] - column vector of size 6
       OUTPUT['x015'] - column vector of size 6
       OUTPUT['x016'] - column vector of size 6
       OUTPUT['x017'] - column vector of size 6
       OUTPUT['x018'] - column vector of size 6
       OUTPUT['x019'] - column vector of size 6
       OUTPUT['x020'] - column vector of size 6
       OUTPUT['x021'] - column vector of size 6
       OUTPUT['x022'] - column vector of size 6
       OUTPUT['x023'] - column vector of size 6
       OUTPUT['x024'] - column vector of size 6
       OUTPUT['x025'] - column vector of size 6
       OUTPUT['x026'] - column vector of size 6
       OUTPUT['x027'] - column vector of size 6
       OUTPUT['x028'] - column vector of size 6
       OUTPUT['x029'] - column vector of size 6
       OUTPUT['x030'] - column vector of size 6
       OUTPUT['x031'] - column vector of size 6
       OUTPUT['x032'] - column vector of size 6
       OUTPUT['x033'] - column vector of size 6
       OUTPUT['x034'] - column vector of size 6
       OUTPUT['x035'] - column vector of size 6
       OUTPUT['x036'] - column vector of size 6
       OUTPUT['x037'] - column vector of size 6
       OUTPUT['x038'] - column vector of size 6
       OUTPUT['x039'] - column vector of size 6
       OUTPUT['x040'] - column vector of size 6
       OUTPUT['x041'] - column vector of size 6
       OUTPUT['x042'] - column vector of size 6
       OUTPUT['x043'] - column vector of size 6
       OUTPUT['x044'] - column vector of size 6
       OUTPUT['x045'] - column vector of size 6
       OUTPUT['x046'] - column vector of size 6
       OUTPUT['x047'] - column vector of size 6
       OUTPUT['x048'] - column vector of size 6
       OUTPUT['x049'] - column vector of size 6
       OUTPUT['x050'] - column vector of size 6
       OUTPUT['x051'] - column vector of size 6
       OUTPUT['x052'] - column vector of size 6
       OUTPUT['x053'] - column vector of size 6
       OUTPUT['x054'] - column vector of size 6
       OUTPUT['x055'] - column vector of size 6
       OUTPUT['x056'] - column vector of size 6
       OUTPUT['x057'] - column vector of size 6
       OUTPUT['x058'] - column vector of size 6
       OUTPUT['x059'] - column vector of size 6
       OUTPUT['x060'] - column vector of size 6
       OUTPUT['x061'] - column vector of size 6
       OUTPUT['x062'] - column vector of size 6
       OUTPUT['x063'] - column vector of size 6
       OUTPUT['x064'] - column vector of size 6
       OUTPUT['x065'] - column vector of size 6
       OUTPUT['x066'] - column vector of size 6
       OUTPUT['x067'] - column vector of size 6
       OUTPUT['x068'] - column vector of size 6
       OUTPUT['x069'] - column vector of size 6
       OUTPUT['x070'] - column vector of size 6
       OUTPUT['x071'] - column vector of size 6
       OUTPUT['x072'] - column vector of size 6
       OUTPUT['x073'] - column vector of size 6
       OUTPUT['x074'] - column vector of size 6
       OUTPUT['x075'] - column vector of size 6
       OUTPUT['x076'] - column vector of size 6
       OUTPUT['x077'] - column vector of size 6
       OUTPUT['x078'] - column vector of size 6
       OUTPUT['x079'] - column vector of size 6
       OUTPUT['x080'] - column vector of size 6
       OUTPUT['x081'] - column vector of size 6
       OUTPUT['x082'] - column vector of size 6
       OUTPUT['x083'] - column vector of size 6
       OUTPUT['x084'] - column vector of size 6
       OUTPUT['x085'] - column vector of size 6
       OUTPUT['x086'] - column vector of size 6
       OUTPUT['x087'] - column vector of size 6
       OUTPUT['x088'] - column vector of size 6
       OUTPUT['x089'] - column vector of size 6
       OUTPUT['x090'] - column vector of size 6
       OUTPUT['x091'] - column vector of size 6
       OUTPUT['x092'] - column vector of size 6
       OUTPUT['x093'] - column vector of size 6
       OUTPUT['x094'] - column vector of size 6
       OUTPUT['x095'] - column vector of size 6
       OUTPUT['x096'] - column vector of size 6
       OUTPUT['x097'] - column vector of size 6
       OUTPUT['x098'] - column vector of size 6
       OUTPUT['x099'] - column vector of size 6
       OUTPUT['x100'] - column vector of size 6

   [OUTPUT, EXITFLAG] = FORCESNLPsolver_py.FORCESNLPsolver_solve(PARAMS) returns additionally
   the integer EXITFLAG indicating the state of the solution with 
       1 - Optimal solution has been found (subject to desired accuracy)
       2 - (only branch-and-bound) A feasible point has been identified for which the objective value is no more than codeoptions.mip.mipgap*100 per cent worse than the global optimum 
       0 - Timeout - maximum number of iterations reached
      -1 - (only branch-and-bound) Infeasible problem (problems solving the root relaxation to the desired accuracy)
      -2 - (only branch-and-bound) Out of memory - cannot fit branch and bound nodes into pre-allocated memory.
      -6 - NaN or INF occured during evaluation of functions and derivatives. Please check your initial guess.
      -7 - Method could not progress. Problem may be infeasible. Run FORCESdiagnostics on your problem to check for most common errors in the formulation.
     -10 - The convex solver could not proceed due to an internal error
    -100 - License error

   [OUTPUT, EXITFLAG, INFO] = FORCESNLPsolver_py.FORCESNLPsolver_solve(PARAMS) returns 
   additional information about the last iterate:
       INFO.it        - number of iterations that lead to this result
       INFO.it2opt    - number of convex solves
       INFO.res_eq    - max. equality constraint residual
       INFO.res_ineq  - max. inequality constraint residual
       INFO.rsnorm    - norm of stationarity condition
       INFO.rcompnorm    - max of all complementarity violations
       INFO.pobj      - primal objective
       INFO.mu        - duality measure
       INFO.solvetime - Time needed for solve (wall clock time)
       INFO.fevalstime - Time needed for function evaluations (wall clock time)

 See also COPYING

'''

import ctypes
import os
import numpy as np
import numpy.ctypeslib as npct
import sys

#_lib = ctypes.CDLL(os.path.join(os.getcwd(),'FORCESNLPsolver/lib/FORCESNLPsolver.dll')) 
try:
	_lib = ctypes.CDLL(os.path.join(os.path.dirname(os.path.abspath(__file__)),'FORCESNLPsolver/lib/FORCESNLPsolver_withModel.dll'))
	csolver = getattr(_lib,'FORCESNLPsolver_solve')
except:
	_lib = ctypes.CDLL(os.path.join(os.path.dirname(os.path.abspath(__file__)),'FORCESNLPsolver/lib/libFORCESNLPsolver_withModel.dll'))
	csolver = getattr(_lib,'FORCESNLPsolver_solve')

class FORCESNLPsolver_params_ctypes(ctypes.Structure):
#	@classmethod
#	def from_param(self):
#		return self
	_fields_ = [('x0', ctypes.c_double * 600),
('xinit', ctypes.c_double * 4),
('xfinal', ctypes.c_double * 2),
]

FORCESNLPsolver_params = {'x0' : np.array([]),
'xinit' : np.array([]),
'xfinal' : np.array([]),
}
params = {'x0' : np.array([]),
'xinit' : np.array([]),
'xfinal' : np.array([]),
}

class FORCESNLPsolver_outputs_ctypes(ctypes.Structure):
#	@classmethod
#	def from_param(self):
#		return self
	_fields_ = [('x001', ctypes.c_double * 6),
('x002', ctypes.c_double * 6),
('x003', ctypes.c_double * 6),
('x004', ctypes.c_double * 6),
('x005', ctypes.c_double * 6),
('x006', ctypes.c_double * 6),
('x007', ctypes.c_double * 6),
('x008', ctypes.c_double * 6),
('x009', ctypes.c_double * 6),
('x010', ctypes.c_double * 6),
('x011', ctypes.c_double * 6),
('x012', ctypes.c_double * 6),
('x013', ctypes.c_double * 6),
('x014', ctypes.c_double * 6),
('x015', ctypes.c_double * 6),
('x016', ctypes.c_double * 6),
('x017', ctypes.c_double * 6),
('x018', ctypes.c_double * 6),
('x019', ctypes.c_double * 6),
('x020', ctypes.c_double * 6),
('x021', ctypes.c_double * 6),
('x022', ctypes.c_double * 6),
('x023', ctypes.c_double * 6),
('x024', ctypes.c_double * 6),
('x025', ctypes.c_double * 6),
('x026', ctypes.c_double * 6),
('x027', ctypes.c_double * 6),
('x028', ctypes.c_double * 6),
('x029', ctypes.c_double * 6),
('x030', ctypes.c_double * 6),
('x031', ctypes.c_double * 6),
('x032', ctypes.c_double * 6),
('x033', ctypes.c_double * 6),
('x034', ctypes.c_double * 6),
('x035', ctypes.c_double * 6),
('x036', ctypes.c_double * 6),
('x037', ctypes.c_double * 6),
('x038', ctypes.c_double * 6),
('x039', ctypes.c_double * 6),
('x040', ctypes.c_double * 6),
('x041', ctypes.c_double * 6),
('x042', ctypes.c_double * 6),
('x043', ctypes.c_double * 6),
('x044', ctypes.c_double * 6),
('x045', ctypes.c_double * 6),
('x046', ctypes.c_double * 6),
('x047', ctypes.c_double * 6),
('x048', ctypes.c_double * 6),
('x049', ctypes.c_double * 6),
('x050', ctypes.c_double * 6),
('x051', ctypes.c_double * 6),
('x052', ctypes.c_double * 6),
('x053', ctypes.c_double * 6),
('x054', ctypes.c_double * 6),
('x055', ctypes.c_double * 6),
('x056', ctypes.c_double * 6),
('x057', ctypes.c_double * 6),
('x058', ctypes.c_double * 6),
('x059', ctypes.c_double * 6),
('x060', ctypes.c_double * 6),
('x061', ctypes.c_double * 6),
('x062', ctypes.c_double * 6),
('x063', ctypes.c_double * 6),
('x064', ctypes.c_double * 6),
('x065', ctypes.c_double * 6),
('x066', ctypes.c_double * 6),
('x067', ctypes.c_double * 6),
('x068', ctypes.c_double * 6),
('x069', ctypes.c_double * 6),
('x070', ctypes.c_double * 6),
('x071', ctypes.c_double * 6),
('x072', ctypes.c_double * 6),
('x073', ctypes.c_double * 6),
('x074', ctypes.c_double * 6),
('x075', ctypes.c_double * 6),
('x076', ctypes.c_double * 6),
('x077', ctypes.c_double * 6),
('x078', ctypes.c_double * 6),
('x079', ctypes.c_double * 6),
('x080', ctypes.c_double * 6),
('x081', ctypes.c_double * 6),
('x082', ctypes.c_double * 6),
('x083', ctypes.c_double * 6),
('x084', ctypes.c_double * 6),
('x085', ctypes.c_double * 6),
('x086', ctypes.c_double * 6),
('x087', ctypes.c_double * 6),
('x088', ctypes.c_double * 6),
('x089', ctypes.c_double * 6),
('x090', ctypes.c_double * 6),
('x091', ctypes.c_double * 6),
('x092', ctypes.c_double * 6),
('x093', ctypes.c_double * 6),
('x094', ctypes.c_double * 6),
('x095', ctypes.c_double * 6),
('x096', ctypes.c_double * 6),
('x097', ctypes.c_double * 6),
('x098', ctypes.c_double * 6),
('x099', ctypes.c_double * 6),
('x100', ctypes.c_double * 6),
]

FORCESNLPsolver_outputs = {'x001' : np.array([]),
'x002' : np.array([]),
'x003' : np.array([]),
'x004' : np.array([]),
'x005' : np.array([]),
'x006' : np.array([]),
'x007' : np.array([]),
'x008' : np.array([]),
'x009' : np.array([]),
'x010' : np.array([]),
'x011' : np.array([]),
'x012' : np.array([]),
'x013' : np.array([]),
'x014' : np.array([]),
'x015' : np.array([]),
'x016' : np.array([]),
'x017' : np.array([]),
'x018' : np.array([]),
'x019' : np.array([]),
'x020' : np.array([]),
'x021' : np.array([]),
'x022' : np.array([]),
'x023' : np.array([]),
'x024' : np.array([]),
'x025' : np.array([]),
'x026' : np.array([]),
'x027' : np.array([]),
'x028' : np.array([]),
'x029' : np.array([]),
'x030' : np.array([]),
'x031' : np.array([]),
'x032' : np.array([]),
'x033' : np.array([]),
'x034' : np.array([]),
'x035' : np.array([]),
'x036' : np.array([]),
'x037' : np.array([]),
'x038' : np.array([]),
'x039' : np.array([]),
'x040' : np.array([]),
'x041' : np.array([]),
'x042' : np.array([]),
'x043' : np.array([]),
'x044' : np.array([]),
'x045' : np.array([]),
'x046' : np.array([]),
'x047' : np.array([]),
'x048' : np.array([]),
'x049' : np.array([]),
'x050' : np.array([]),
'x051' : np.array([]),
'x052' : np.array([]),
'x053' : np.array([]),
'x054' : np.array([]),
'x055' : np.array([]),
'x056' : np.array([]),
'x057' : np.array([]),
'x058' : np.array([]),
'x059' : np.array([]),
'x060' : np.array([]),
'x061' : np.array([]),
'x062' : np.array([]),
'x063' : np.array([]),
'x064' : np.array([]),
'x065' : np.array([]),
'x066' : np.array([]),
'x067' : np.array([]),
'x068' : np.array([]),
'x069' : np.array([]),
'x070' : np.array([]),
'x071' : np.array([]),
'x072' : np.array([]),
'x073' : np.array([]),
'x074' : np.array([]),
'x075' : np.array([]),
'x076' : np.array([]),
'x077' : np.array([]),
'x078' : np.array([]),
'x079' : np.array([]),
'x080' : np.array([]),
'x081' : np.array([]),
'x082' : np.array([]),
'x083' : np.array([]),
'x084' : np.array([]),
'x085' : np.array([]),
'x086' : np.array([]),
'x087' : np.array([]),
'x088' : np.array([]),
'x089' : np.array([]),
'x090' : np.array([]),
'x091' : np.array([]),
'x092' : np.array([]),
'x093' : np.array([]),
'x094' : np.array([]),
'x095' : np.array([]),
'x096' : np.array([]),
'x097' : np.array([]),
'x098' : np.array([]),
'x099' : np.array([]),
'x100' : np.array([]),
}


class FORCESNLPsolver_info(ctypes.Structure):
#	@classmethod
#	def from_param(self):
#		return self
	_fields_ = [('it', ctypes.c_int),
('it2opt', ctypes.c_int),
('res_eq', ctypes.c_double),
('res_ineq', ctypes.c_double),
('rsnorm', ctypes.c_double),
('rcompnorm', ctypes.c_double),
('pobj',ctypes.c_double),
('dobj',ctypes.c_double),
('dgap',ctypes.c_double),
('rdgap',ctypes.c_double),
('mu',ctypes.c_double),
('mu_aff',ctypes.c_double),
('sigma',ctypes.c_double),
('lsit_aff', ctypes.c_int),
('lsit_cc', ctypes.c_int),
('step_aff',ctypes.c_double),
('step_cc',ctypes.c_double),
('solvetime',ctypes.c_double),
('fevalstime',ctypes.c_double)
]

class FILE(ctypes.Structure):
        pass
if sys.version_info.major == 2:
	PyFile_AsFile = ctypes.pythonapi.PyFile_AsFile # problem here with python 3 http://stackoverflow.com/questions/16130268/python-3-replacement-for-pyfile-asfile
	PyFile_AsFile.argtypes = [ctypes.py_object]
	PyFile_AsFile.restype = ctypes.POINTER(FILE)

# determine data types for solver function prototype 
csolver.argtypes = ( ctypes.POINTER(FORCESNLPsolver_params_ctypes), ctypes.POINTER(FORCESNLPsolver_outputs_ctypes), ctypes.POINTER(FORCESNLPsolver_info), ctypes.POINTER(FILE))
csolver.restype = ctypes.c_int

def FORCESNLPsolver_solve(params_arg):
	'''
a Python wrapper for a fast solver generated by FORCES Pro v1.6.121

   OUTPUT = FORCESNLPsolver_py.FORCESNLPsolver_solve(PARAMS) solves a multistage problem
   subject to the parameters supplied in the following dictionary:
       PARAMS['x0'] - column vector of length 600
       PARAMS['xinit'] - column vector of length 4
       PARAMS['xfinal'] - column vector of length 2

   OUTPUT returns the values of the last iteration of the solver where
       OUTPUT['x001'] - column vector of size 6
       OUTPUT['x002'] - column vector of size 6
       OUTPUT['x003'] - column vector of size 6
       OUTPUT['x004'] - column vector of size 6
       OUTPUT['x005'] - column vector of size 6
       OUTPUT['x006'] - column vector of size 6
       OUTPUT['x007'] - column vector of size 6
       OUTPUT['x008'] - column vector of size 6
       OUTPUT['x009'] - column vector of size 6
       OUTPUT['x010'] - column vector of size 6
       OUTPUT['x011'] - column vector of size 6
       OUTPUT['x012'] - column vector of size 6
       OUTPUT['x013'] - column vector of size 6
       OUTPUT['x014'] - column vector of size 6
       OUTPUT['x015'] - column vector of size 6
       OUTPUT['x016'] - column vector of size 6
       OUTPUT['x017'] - column vector of size 6
       OUTPUT['x018'] - column vector of size 6
       OUTPUT['x019'] - column vector of size 6
       OUTPUT['x020'] - column vector of size 6
       OUTPUT['x021'] - column vector of size 6
       OUTPUT['x022'] - column vector of size 6
       OUTPUT['x023'] - column vector of size 6
       OUTPUT['x024'] - column vector of size 6
       OUTPUT['x025'] - column vector of size 6
       OUTPUT['x026'] - column vector of size 6
       OUTPUT['x027'] - column vector of size 6
       OUTPUT['x028'] - column vector of size 6
       OUTPUT['x029'] - column vector of size 6
       OUTPUT['x030'] - column vector of size 6
       OUTPUT['x031'] - column vector of size 6
       OUTPUT['x032'] - column vector of size 6
       OUTPUT['x033'] - column vector of size 6
       OUTPUT['x034'] - column vector of size 6
       OUTPUT['x035'] - column vector of size 6
       OUTPUT['x036'] - column vector of size 6
       OUTPUT['x037'] - column vector of size 6
       OUTPUT['x038'] - column vector of size 6
       OUTPUT['x039'] - column vector of size 6
       OUTPUT['x040'] - column vector of size 6
       OUTPUT['x041'] - column vector of size 6
       OUTPUT['x042'] - column vector of size 6
       OUTPUT['x043'] - column vector of size 6
       OUTPUT['x044'] - column vector of size 6
       OUTPUT['x045'] - column vector of size 6
       OUTPUT['x046'] - column vector of size 6
       OUTPUT['x047'] - column vector of size 6
       OUTPUT['x048'] - column vector of size 6
       OUTPUT['x049'] - column vector of size 6
       OUTPUT['x050'] - column vector of size 6
       OUTPUT['x051'] - column vector of size 6
       OUTPUT['x052'] - column vector of size 6
       OUTPUT['x053'] - column vector of size 6
       OUTPUT['x054'] - column vector of size 6
       OUTPUT['x055'] - column vector of size 6
       OUTPUT['x056'] - column vector of size 6
       OUTPUT['x057'] - column vector of size 6
       OUTPUT['x058'] - column vector of size 6
       OUTPUT['x059'] - column vector of size 6
       OUTPUT['x060'] - column vector of size 6
       OUTPUT['x061'] - column vector of size 6
       OUTPUT['x062'] - column vector of size 6
       OUTPUT['x063'] - column vector of size 6
       OUTPUT['x064'] - column vector of size 6
       OUTPUT['x065'] - column vector of size 6
       OUTPUT['x066'] - column vector of size 6
       OUTPUT['x067'] - column vector of size 6
       OUTPUT['x068'] - column vector of size 6
       OUTPUT['x069'] - column vector of size 6
       OUTPUT['x070'] - column vector of size 6
       OUTPUT['x071'] - column vector of size 6
       OUTPUT['x072'] - column vector of size 6
       OUTPUT['x073'] - column vector of size 6
       OUTPUT['x074'] - column vector of size 6
       OUTPUT['x075'] - column vector of size 6
       OUTPUT['x076'] - column vector of size 6
       OUTPUT['x077'] - column vector of size 6
       OUTPUT['x078'] - column vector of size 6
       OUTPUT['x079'] - column vector of size 6
       OUTPUT['x080'] - column vector of size 6
       OUTPUT['x081'] - column vector of size 6
       OUTPUT['x082'] - column vector of size 6
       OUTPUT['x083'] - column vector of size 6
       OUTPUT['x084'] - column vector of size 6
       OUTPUT['x085'] - column vector of size 6
       OUTPUT['x086'] - column vector of size 6
       OUTPUT['x087'] - column vector of size 6
       OUTPUT['x088'] - column vector of size 6
       OUTPUT['x089'] - column vector of size 6
       OUTPUT['x090'] - column vector of size 6
       OUTPUT['x091'] - column vector of size 6
       OUTPUT['x092'] - column vector of size 6
       OUTPUT['x093'] - column vector of size 6
       OUTPUT['x094'] - column vector of size 6
       OUTPUT['x095'] - column vector of size 6
       OUTPUT['x096'] - column vector of size 6
       OUTPUT['x097'] - column vector of size 6
       OUTPUT['x098'] - column vector of size 6
       OUTPUT['x099'] - column vector of size 6
       OUTPUT['x100'] - column vector of size 6

   [OUTPUT, EXITFLAG] = FORCESNLPsolver_py.FORCESNLPsolver_solve(PARAMS) returns additionally
   the integer EXITFLAG indicating the state of the solution with 
       1 - Optimal solution has been found (subject to desired accuracy)
       2 - (only branch-and-bound) A feasible point has been identified for which the objective value is no more than codeoptions.mip.mipgap*100 per cent worse than the global optimum 
       0 - Timeout - maximum number of iterations reached
      -1 - (only branch-and-bound) Infeasible problem (problems solving the root relaxation to the desired accuracy)
      -2 - (only branch-and-bound) Out of memory - cannot fit branch and bound nodes into pre-allocated memory.
      -6 - NaN or INF occured during evaluation of functions and derivatives. Please check your initial guess.
      -7 - Method could not progress. Problem may be infeasible. Run FORCESdiagnostics on your problem to check for most common errors in the formulation.
     -10 - The convex solver could not proceed due to an internal error
    -100 - License error

   [OUTPUT, EXITFLAG, INFO] = FORCESNLPsolver_py.FORCESNLPsolver_solve(PARAMS) returns 
   additional information about the last iterate:
       INFO.it        - number of iterations that lead to this result
       INFO.it2opt    - number of convex solves
       INFO.res_eq    - max. equality constraint residual
       INFO.res_ineq  - max. inequality constraint residual
       INFO.rsnorm    - norm of stationarity condition
       INFO.rcompnorm    - max of all complementarity violations
       INFO.pobj      - primal objective
       INFO.mu        - duality measure
       INFO.solvetime - Time needed for solve (wall clock time)
       INFO.fevalstime - Time needed for function evaluations (wall clock time)

 See also COPYING

	'''
	global _lib

	# convert parameters
	params_py = FORCESNLPsolver_params_ctypes()
	for par in params_arg:
		try:
			#setattr(params_py, par, npct.as_ctypes(np.reshape(params_arg[par],np.size(params_arg[par]),order='A'))) 
			params_arg[par] = np.require(params_arg[par], dtype=np.float64, requirements='F')
			setattr(params_py, par, npct.as_ctypes(np.reshape(params_arg[par],np.size(params_arg[par]),order='F')))  
		except:
			raise ValueError('Parameter ' + par + ' does not have the appropriate dimensions or data type. Please use numpy arrays for parameters.')
    
	outputs_py = FORCESNLPsolver_outputs_ctypes()
	info_py = FORCESNLPsolver_info()
	if sys.version_info.major == 2:
		if sys.platform.startswith('win'):
			fp = None # if set to none, the solver prints to stdout by default - necessary because we have an access violation otherwise under windows
		else:
			#fp = open('stdout_temp.txt','w')
			fp = sys.stdout
		try:
			PyFile_AsFile.restype = ctypes.POINTER(FILE)
			exitflag = _lib.FORCESNLPsolver_solve( params_py, ctypes.byref(outputs_py), ctypes.byref(info_py), PyFile_AsFile(fp) , _lib.FORCESNLPsolver_casadi2forces )
			#fp = open('stdout_temp.txt','r')
			#print (fp.read())
			#fp.close()
		except:
			#print 'Problem with solver'
			raise
	elif sys.version_info.major == 3:
		if sys.platform.startswith('win'):
			libc = ctypes.cdll.msvcrt
		elif sys.platform.startswith('darwin'):
			libc = ctypes.CDLL('libc.dylib')
		else:
			libc = ctypes.CDLL('libc.so.6')       # Open libc
		cfopen = getattr(libc,'fopen')        # Get its fopen
		cfopen.restype = ctypes.POINTER(FILE) # Yes, fopen gives a file pointer
		cfopen.argtypes = [ctypes.c_char_p, ctypes.c_char_p] # Yes, fopen gives a file pointer 
		fp = cfopen('stdout_temp.txt'.encode('utf-8'),'w'.encode('utf-8'))    # Use that fopen 

		try:
			if sys.platform.startswith('win'):
				exitflag = _lib.FORCESNLPsolver_solve( params_py, ctypes.byref(outputs_py), ctypes.byref(info_py), None , _lib.FORCESNLPsolver_casadi2forces)
			else:
				exitflag = _lib.FORCESNLPsolver_solve( params_py, ctypes.byref(outputs_py), ctypes.byref(info_py), fp , _lib.FORCESNLPsolver_casadi2forces)
			libc.fclose(fp)
			fptemp = open('stdout_temp.txt','r')
			print (fptemp.read())
			fptemp.close()			
		except:
			#print 'Problem with solver'
			raise

	# convert outputs
	for out in FORCESNLPsolver_outputs:
		FORCESNLPsolver_outputs[out] = npct.as_array(getattr(outputs_py,out))

	return FORCESNLPsolver_outputs,int(exitflag),info_py

solve = FORCESNLPsolver_solve


