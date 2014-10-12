% eegplugin_writesLOR() - EEGLAB plugin for writing sLORETA formated files data.
%
% Usage:
%   >> writesLORplugin(fig, try_strings, catch_stringss);
%
% Inputs:
%   fig            - [integer]  EEGLAB figure
%   try_strings    - [struct] "try" strings for menu callbacks.
%   catch_strings  - [struct] "catch" strings for menu callbacks.
%
%
% Copyright (C) <2010> <James Desjardins> Brock University
%
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

% $Log: writesLORplugin.m

function eegplugin_writesLOR(fig,try_strings,catch_strings)


% Find "Export" submenu.
exportmenu=findobj(fig,'tag','export');

% Create cmd for Export functions.
cmd='[LASTCOM] = pop_writesLORdat( EEG );';
finalcmdwsLd=[try_strings.no_check cmd catch_strings.store_and_hist];

cmd='[LASTCOM] = pop_writesLORdatIC( EEG );';
finalcmdwsLdIC=[try_strings.no_check cmd catch_strings.store_and_hist];

cmd='[LASTCOM] = pop_writesLORcoord( EEG );';
finalcmdwsLc=[try_strings.no_check cmd catch_strings.store_and_hist];

cmd='[LASTCOM] = pop_writesLORlndmrk( EEG );';
finalcmdwsLl=[try_strings.no_check cmd catch_strings.store_and_hist];

% add specific submenus to "Export" menu.
sLORmenu = uimenu(exportmenu,'label', 'sLORETA exports');
uimenu(sLORmenu,'label','sLORETA data','callback',finalcmdwsLd);
uimenu(sLORmenu,'label','sLORETA IC projections','callback',finalcmdwsLdIC);
uimenu(sLORmenu,'label','sLORETA channel coordinates','callback',finalcmdwsLc);
uimenu(sLORmenu,'label','sLORETA landmark coordinates','callback',finalcmdwsLl);
