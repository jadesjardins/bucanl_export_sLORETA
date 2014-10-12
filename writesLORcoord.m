% pop_writesLORcoord() - Writes EEG channel coordinates to the sLORETA .xyz
%                       format.
%
% Usage:
%   >>  com= pop_writesLORcoord(EEG, outfname, outfpath, varargin);
%
% Inputs:
%   EEG         - input EEG structure
%   outfname    - output file name string
%   outfpath    - output path string
%   varargin    - key/val pairs. See Options.
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
% Outputs:
%   com         - writesLORcoord command string
%
% See also:
%   writesLORdat, writesLORlndmrk 

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

function writesLORcoord(EEG,outfname,outfpath,varargin)

g = struct(varargin{:});

try g.coordfname;   catch, g.coordfname = '';      end;
try g.yxzconst;     catch, g.yxzconst   = [1,1,1]; end;

if ~isempty(g.coordfname);
    chanlocs=readlocs(g.coordfname);
else
    chanlocs=EEG.chanlocs;
end

chanlabs={EEG.chanlocs.labels};


for chani = 1:EEG.nbchan;
    for coordi=1:length(chanlocs);
        if strcmp(strtrim(chanlabs{chani}),strtrim(chanlocs(coordi).labels));
            chans(chani).labels=chanlocs(coordi).labels;
            chans(chani).Y=chanlocs(coordi).Y;
            chans(chani).X=chanlocs(coordi).X;
            chans(chani).Z=chanlocs(coordi).Z;
            break
        end
    end
end


chan_out=sprintf('%s\r\n',num2str(EEG.nbchan));

for chani=1:EEG.nbchan;
    chan_out=sprintf('%s%6.4f\t%6.4f\t%6.4f\t%s\r\n', chan_out, ...
                        chans(chani).Y*g.yxzconst(1), ...
                        chans(chani).X*g.yxzconst(2), ...
                        chans(chani).Z*g.yxzconst(3), ...
                        chans(chani).labels);
end

fidchan=fopen(fullfile(outfpath,outfname),'w');
fwrite(fidchan,chan_out,'char');

fclose(fidchan);