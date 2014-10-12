% pop_writesLORdat() - collects inputs for writesLORdat which writes EEG
% data to the sLORETA ascii format.
%
% Usage:
%   >>  com= pop_writesLORdatIC(EEG, outfname, outfpath, optstr);
%
% Inputs:
%   EEG         - input EEG structure
%   outfname    - output file name string
%   outfpath    - output path string
%   optstr      - string containing writesLORdat key/val pairs for varargin
%
% Options:
%   data        - data vector to be written... default = EEG.data'.
%               _ eg. if EEG structure contains segmented file use:
%                   'data',mean(EEG.data,3)'
%   icinds      - indices of components to export (e.g, 'icinds', [14,5,2,1])
%
% Outputs:
%   com         - writesLORdat command string
%
% See also:
%   writesLORcoord, writesLORlndmrk 

% Copyright (C) <2010>  <James Desjardins>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function com = pop_writesLORdatIC(EEG, outfname, outfpath, optstr)

% the command output is a hidden output that does not have to
% be described in the header
com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_writesLORdatIC;
	return;
end;	


% pop up window
% -------------

if nargin < 3
    
    for i=1:size(EEG.comments(:,1));
        if 	strcmp(EEG.comments(i,1:14),'Original file:');
            outfname=strtrim(EEG.comments(i,15:length(EEG.comments(i,:))));
            outfname=[outfname,'.dat.txt'];
        end
    end
    
    [pathstr, filestr, extstr] = fileparts(outfname); 
     
    results=inputgui( ...
    {[1] [1] [1] [1 6] [1] [1] [8 1] [1] [1] [1] [1]}, ...
    {...
        {'Style', 'text', 'string', 'Enter sLORETA IC projection export parameters.', 'FontWeight', 'bold'}, ...
        {'Style', 'text', 'string', 'In order for this function to be batch compatible default file name and path must be used.'}, ...
        {}, ...
        {'Style', 'text', 'string', 'File name:'}, ...
        {'Style', 'edit', 'tag', 'FileNameDisp', 'string', [filestr,extstr]}, ...
        {}, ...
        {'Style', 'text', 'string', 'File path:'}, ...
        {'Style', 'edit', 'tag', 'FilePathDisp', 'string', pathstr}, ...
        {'Style', 'pushbutton', 'string', '...', ...
        'callback', '[FilePath] = uigetdir(cd,''Select file path:''); set(findobj(gcbf,''tag'', ''FilePathDisp''), ''string'', FilePath);'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Optional key val parameters:'}, ...
        {'Style', 'edit', 'string', ''}, ...
        {}, ...
    }, ...   
     'pophelp(''pop_writesLORdat'');', 'Select sLORETA export parameters -- pop_writesLORdatIC()' ...
     );
 
     if isempty(results);return;end;
    
     outfname         = results{1};
     outfpath         = results{2};
     optstr           = results{3};
end;


% return the string command
% -------------------------

if isempty(optstr);
    com = sprintf('writesLORdatIC( %s, ''%s'', ''%s'');', inputname(1), outfname, outfpath);
else
    com = sprintf('writesLORdatIC( %s, ''%s'', ''%s'', %s );', inputname(1), outfname, outfpath, optstr);
end

% call function sample either on raw data or ICA data
% ---------------------------------------------------

eval(com)
