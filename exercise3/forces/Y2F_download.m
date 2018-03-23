function target = Y2F_download(version, silent, target)
% Download Y2F, the Yalmip-FORCES interface.
%
%    Y2F_DOWNLOAD() downloads the master branch of Y2F and unpacks 
%    it into the directory 'Y2F'. If that directory exists, the user is 
%    prompted to confirm deleting the existing directory.
%
%    Y2F_DOWNLOAD(VERSION) downloads the tag 'v{VERSION}' of Y2F and unpacks 
%    it into the directory 'Y2F'. If that directory exists, the user is 
%    prompted to confirm deleting the existing directory.
%
%    Y2F_DOWNLOAD(VERSION,SILENT) As above, and for SILENT==TRUE no prompt will be
%    displayed - any existing directory will be deleted. If VERSION is an
%    empty matrix [], the master branch will be retrieved.
%
%    Y2F_DOWNLOAD(VERSION, SILENT, TARGET) As above, but the contents of 
%    Y2F will be placed into the directory defined in the string TARGET.
%
% See also Y2F_INSTALL
%
% This file is part of the FORCES Pro client software for Matlab.
% (c) embotech AG, 2013-2018, Zurich, Switzerland. All rights reserved.

if nargin == 0 || isempty(version)
    version = 'master';    
    src = ['https://github.com/embotech/Y2F/archive/master.zip'];
else
    % strip out v at the beginnig
    if( version(1)=='V' || version(1)=='v' )
        version = version(2:end);
    end
    
    % test whether it has the right format
    if( length(strfind(version,'.'))~=2 )
        error('Version number must have format [v]X.Y.Z');
    end
    
    src = ['https://github.com/embotech/Y2F/archive/v',version,'.zip'];
end

if nargin <= 1
    silent = false;
end

if nargin <= 2 
    w = what;
    target = [w.path,filesep,'Y2F'];
end
    
%% Download
fprintf('Downloading Y2F from %s...', src);
urlwrite(src, 'y2f.zip');
fprintf('   [OK]\n');


%% Remove existing directory
if exist(target,'dir')
    if( ~silent)
        answer = input(sprintf('Existing directory %s will be deleted. Continue? [y]/n ',target),'s');
    else
        answer = 'y';
    end
    
    if( silent || isempty(answer) || lower(answer)=='y' )
        rmdir(target,'s');
    else
        delete('y2f.zip');
        fprintf('Operation aborted\n');
        return;
    end
end


%% Unzip 
fprintf('Extracting ZIP package into %s...', target);
unzip('y2f.zip');
movefile(['Y2F-',version],target);
fprintf('   [OK]\n');

%% Remove y2f.zip
delete('y2f.zip');
