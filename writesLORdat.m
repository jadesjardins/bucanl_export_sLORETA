% writesLORdat() - write EEG data to sLORETA ascii format.
%
% Usage:
%   >>  com= writesLORdaat(EEG, outfname, outfpath, varargin);
%
% Inputs:
%   EEG         - input EEG structure
%   outfname    - output file name string
%   outfpath    - output path string
%   varargin    - key/val option pairs... see Options for details
%
% Options:
%   data        - data vector to be written... default = EEG.data'.
%               _ eg. if EEG structure contains segmented file use:
%                   mean(EEG.data,3)'
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

function writesLORdat(EEG,outfname,outfpath,varargin)

if ~isempty(varargin);
    g = struct(varargin{:});
else
    g=struct;
end

try g.data; catch, g.data = EEG.data'; end;

dlmwrite(fullfile(outfpath,outfname),g.data,'delimiter','\t','newline','pc')