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
%   lndmrklabs  - Cell of string channel names that represent the locations
%               of the sLORETA landmarks. The required and order specific 
%               landmarks for sLORETA are:
%               Nz, Iz, RPA, LPA, Cz. (e.g., BioSemi =
%               {'NZ','A13','RPA','LPA','C10'}...
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

function chans = writesLORlndmrk(EEG,outfname,outfpath,lndmrklabs,varargin)

g = struct(varargin{:});

try g.coordfname;         catch, g.coordfname     = '';                           end;
try g.yxzconst;           catch, g.yxzconst       = [1,1,1];                      end;
try g.lndmrklabsout;      catch, g.lndmrklabsout  = {'Nz','Iz','RPA','LPA','Cz'}; end;

if ~isempty(g.coordfname)
    chanlocs=readlocs(g.coordfname);
else
    chanlocs=EEG.chanlocs;
    for i=1:length(EEG.chaninfo.nodatchans);
        chanlocs(EEG.nbchan+i).labels=EEG.chaninfo.nodatchans(i).labels;
        chanlocs(EEG.nbchan+i).Y=EEG.chaninfo.nodatchans(i).Y;
        chanlocs(EEG.nbchan+i).X=EEG.chaninfo.nodatchans(i).X;
        chanlocs(EEG.nbchan+i).Z=EEG.chaninfo.nodatchans(i).Z;
    end
end

for chani = 1:length(lndmrklabs);
    for coordi=1:length(chanlocs);
        if strcmp(strtrim(lndmrklabs{chani}),strtrim(chanlocs(coordi).labels));
            chans(chani).labels=g.lndmrklabsout{chani};
            chans(chani).Y=chanlocs(coordi).Y;
            chans(chani).X=chanlocs(coordi).X;
            chans(chani).Z=chanlocs(coordi).Z;
            break
        end
    end
end


chan_out=sprintf('%s\r\n',num2str(length(chans)));

for chani=1:length(chans);
    chan_out=sprintf('%s%6.4f\t%6.4f\t%6.4f\t%s\r\n', chan_out, ...
                        chans(chani).Y*g.yxzconst(1), ...
                        chans(chani).X*g.yxzconst(2), ...
                        chans(chani).Z*g.yxzconst(3), ...
                        chans(chani).labels);
end

fidchan=fopen(fullfile(outfpath,outfname),'w');
fwrite(fidchan,chan_out,'char');

fclose(fidchan);