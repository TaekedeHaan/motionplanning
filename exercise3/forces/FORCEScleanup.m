% Cleans up directory from FORCES artifacts.
%
%   --- USE WITH CARE, THIS FUNCTION DELETES FILES FROM YOUR SYSTEM! ---
%   ---      WHENEVER POSSIBLE, WE TURN ON THE RECYCLE OPTION        ---
%
% 
%    FORCESCLEANUP(SOLVERNAME) removes artifacts that are placed during
%    the code generation of a solver named SOLVERNAME in the current
%    directory. It removes only files and directories that are not needed 
%    for running the solver in Matlab:
%
%       - the @CodeGen directory (from older FORCES versions)
%       - ZIP file <SOLVERNAME>.zip
%       - C-files:
%           * model_i.c
%           * model_N.c
%           * casadi2forces.c
%       - Object files:
%           * <SOLVERNAME>.[o,obj]
%           * <SOLVERNAME>_simulinkBlock.[o,obj,pdb]
%           * <SOLVERNAME>_simulinkBlockcompact.[o,obj,pdb]
%       - Temporary file for solver prints: stdout_temp 
%
%
%    FORCESCLEANUP(SOLVERNAME,'all') cleans up more thoroughly, deleting
%    all files placed by the code generator into the current directory:
%
%       - the @FORCESproWS directory
%       - the solverdirectory <SOLVERNAME>
%       - MEX FILES:
%           * <SOLVERNAME>.<mexext>
%           * <SOLVERNAME>_simulinkBlock.<mexext>
%           * <SOLVERNAME>_simulinkBlockcompact.<mexext>
%       - Matlab help file: <SOLVERNAME>.m
%
%
%    FORCESCLEANUP(SOLVERNAME, MODE, DIR) as above, but perform cleanup of 
%    the directory DIR. To perform only a partial cleanup of DIR, use 
%    MODE = 'partial'. 
%
%
%    FORCESCLEANUP(SOLVERNAME, MODE, DIR, SILENT) as above but suppresses 
%    printing if SILENT==1. Set DIR=[] (empty matrix) if you want to clean
%    the current directory.
%
%
% This file is part of the FORCES Pro client software for Matlab.
% (c) embotech AG, 2013-2018, Zurich, Switzerland. All rights reserved.
