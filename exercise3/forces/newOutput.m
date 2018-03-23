% Shortcut code to define an output of the FORCES solver.
% 
%    OUTVAR = NEWOUTPUT(NAME, FROMSTAGE, IDXWITHINSTAGE) returns a struct
%    that defines a valid output to be used with the FORCES code generator,
%    where NAME is a label of the output, FROMSTAGE defines from which
%    stage variable the output is retrieved, and IDXWITHINSTAGE defines the
%    indices within that stage variable.
%
%    Example: 1) to have variables 5 to 8 from stage variable 11 as outputs of
%                the generated solver, call
%                    
%                   output = newOutput('myoutput', 11, 5:8);
%
%             2) to collect all variables with index 3 and 4 from all
%                stages N, call
%
%                   output = newOutput('myoutput', 3:4, 1:N);
%
% For a detailed explanation for declaring different outputs with FORCES Pro 
% please consult the documentation
%
% % For the "low-level" interface:
% https://www.embotech.com/FORCES-Pro/User-Manual/Low-level-Interface/Declaring-Outputs
%
% For the "high-level" interface:
% https://www.embotech.com/FORCES-Pro/User-Manual/High-level-Interface/Declaring-Outputs
%
%
% This file is part of the FORCES Pro client software for Matlab.
% (c) embotech AG, 2013-2018, Zurich, Switzerland. All rights reserved.
%
% See also getAllOutputs FORCES_LICENSE FORCESversion

