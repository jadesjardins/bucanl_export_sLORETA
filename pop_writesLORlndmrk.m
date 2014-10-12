% pop_writesLORcoord() - collects inputs for writesLORcoord which writes EEG
% channel coordinates to the sLORETA .xyz format.
%
% Usage:
%   >>  com= pop_writesLORcoord(EEG, outfname, outfpath, optstr);
%
% Inputs:
%   EEG         - input EEG structure
%   outfname    - output file name string
%   outfpath    - output path string
%   lndmrklabs  - Cell array of string channel labels that represent the locations
%               of the sLORETA landmarks. The required and order specific 
%               landmarks for sLORETA are:
%               Nz, Iz, RPA, LPA, Cz.
%   optstr      - string containing writesLORlndmrk key/val pairs for
%               varargin. See Options.
%
% Options:
%   coordfname  - Coordinate file name string. The file should contain the
%               coordinates for the channels contained in the EEG structure.
%               The EEG structure must contain channel labels that match
%               channel names in the coordinate file. The channels in the
%               EEG structure do not need to match the order of the
%               channels in the coordinate file, nor does there need to be
%               the same number of channels in the EEG structure and
%               coordinate file. In order for this to be successful in
%               sLORETA all channels in the EEG structure need to be
%               represented in the coordinate file.
%   yxzconst    - Vector contain values with which to multiply each
%               dimmension of the .xyz file. Default = [1,1,1]. eg. If the
%               y dimension needs to be inverted use: 'yxzconst', [-1,1,1].
%   lndmrklabsout - Cell array of string labels to for landmarks in output
%                   file. Default = {'Nz','Iz','RPA','LPA','Cz'}. sLORETA
%                   currently expects the default values listed above.
%
% Outputs:
%   com         - writesLORlndmrk command string
%
% See also:
%   writesLORdat, writesLORcoord 

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

function com = pop_writesLORlndmrk(EEG, outfname, outfpath, lndmrklabs, optstr)

% the command output is a hidden output that does not have to
% be described in the header
com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_writesLORcoord;
	return;
end;	

% pop up window
% -------------

if nargin < 3
    
    for i=1:size(EEG.comments(:,1));
        if 	strcmp(EEG.comments(i,1:14),'Original file:');
            outfname=strtrim(EEG.comments(i,15:length(EEG.comments(i,:))));
            outfname=[outfname,'.lndmrk.xyz'];
        end
    end
    
    [pathstr, filestr, extstr] = fileparts(outfname); 
     
    results=inputgui( ...
    {[1] [1] [1] [1 6] [1] [1] [8 1] [1] [1] [1] [1] [1] [1]}, ...
    {...
        {'Style', 'text', 'string', 'Enter sLORETA channel coordinate export parameters.', 'FontWeight', 'bold'}, ...
        {'Style', 'text', 'string', 'In order for this function to be batch compatible default file name and path must be used.'}, ...
        {}, ...
        {'Style', 'text', 'string', 'File name:'}, ...
        {'Style', 'edit', 'tag', 'FileNameDisp', 'string', [filestr,extstr]}, ...
        {}, ...
        {'Style', 'text', 'string', 'File path:'}, ...
        {'Style', 'edit', 'tag', 'FilePathDisp', 'string', pathstr}, ...
        {'Style', 'pushbutton', 'string', '...', ...
        'callback', '[FilePath] = uigetdir(cd,''Select file path:''); set(findobj(gcbf,''tag'', ''FilePathDisp''), ''string'', char(FilePath));'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Cell array of channel names representing sLORETA landmarks:'}, ...
        {'Style', 'edit', 'string', ''}, ...
        {'Style', 'text', 'string', 'Optional key val parameters:'}, ...
        {'Style', 'edit', 'string', ''}, ...
        {}, ...
    }, ...   
     'pophelp(''pop_writesLORlndmrk'');', 'Select sLORETA landmark export parameters -- pop_writesLORlndmrk()' ...
     );

     if isempty(results);return;end;
 
     outfname        = results{1};
     outfpath        = results{2};
     lndmrklabs      = results{3};
     optstr          = results{4};
end;


% Make sure that coordinates are available at this point.
if ~isfield(EEG.chanlocs,'Y')&&isempty(strfind(optstr,'coordfname'))
    [tmpname,tmppath]=uigetfile({'*.*'},'Select file containing channel coordinates:');
    coordfname=fullfile(tmppath,tmpname);
    if isempty(optstr);
        optstr=['''coordfname'', ''' coordfname ''''];
    else
        optstr=[optstr ', ''coordfname'', ''' coordfname ''''];
    end
end

% return the string command
% -------------------------

if isempty(optstr);
    com = sprintf('writesLORlndmrk( %s, ''%s'', ''%s'', %s);', inputname(1), outfname, outfpath, lndmrklabs);
else
    com = sprintf('writesLORlndmrk( %s, ''%s'', ''%s'', %s, %s );', inputname(1), outfname, outfpath, lndmrklabs, optstr);
end

% call function sample either on raw data or ICA data
% ---------------------------------------------------

eval(com)

