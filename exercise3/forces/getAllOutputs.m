% Shortcut code to generate list of outputs such that all variables are
% included. 
%
%    OUTPUTS = getAllOutputs(STAGES) creates an output struct for use with
%    FORCES Pro that returns all variables as outputs, separated according
%    to stage. The default name of the variables is "z", appended by the
%    stage number.
%
%    OUTPUTS = getAllOutputs(STAGES, NAME) as above, but instead of "z" use
%    the string NAME to define the output. The stage number is
%    automatically appended.
%
% For a detailed explanation for declaring different outputs with FORCES Pro 
% please consult the documentation at
% https://www.embotech.com/FORCES-Pro/How-to-use/MATLAB-Interface/Declaring-Outputs
%
% 
% This file is part of the FORCES Pro client software for Matlab.
% (c) embotech AG, 2013-2018, Zurich, Switzerland. All rights reserved.
%
% See also newOutput

