% KNAPSACK_DEMO Demo of knapsack problem
%
% Demo of knapsack represents the longest way by graph.
%
% See also FLOYD
%
% Author(s): E. Han�kov�, M. Kutil
% Copyright (c) 2007 CTU FEE
% $Revision: 2199 $  $Date: 2008-02-01 16:33:58 +0100 (pá, 01 II 2008) $

% This file is part of TORSCHE Scheduling Toolbox for Matlab.
% TORSCHE Scheduling Toolbox for Matlab can be used, copied 
% and modified under the next licenses
%
% - GPL - GNU General Public License
%
% - and other licenses added by project originators or responsible
%
% Code can be modified and re-distributed under any combination
% of the above listed licenses. If a contributor does not agree
% with some of the licenses, he/she can delete appropriate line.
% If you delete all lines, you are not allowed to distribute 
% source code and/or binaries utilizing code.
%
% --------------------------------------------------------------
%                  GNU General Public License  
%
% TORSCHE Scheduling Toolbox for Matlab is free software;
% you can redistribute it and/or modify it under the terms of the
% GNU General Public License as published by the Free Software
% Foundation; either version 2 of the License, or (at your option)
% any later version.
% 
% TORSCHE Scheduling Toolbox for Matlab is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or 
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with TORSCHE Scheduling Toolbox for Matlab; if not, write
% to the Free Software Foundation, Inc., 59 Temple Place,
% Suite 330, Boston, MA 02111-1307 USA

clc;
disp('Demo of knapsack problem.');
disp('-------------------------------------------');
disp ('weight = [7 6 4 3]');
disp ('cost = [2 3 4 5]');
disp ('maxWeight = 15');

close(torsche.graphedit);
monitor = get(0,'ScreenSize');
height = 700;
width = 900;
colors = 1;
torsche.graphedit('position',[(monitor(3)-width)/2, (monitor(4)-height)/2 width height],...
    'hideparts','all','viewnodesnames','off','propertyeditor','off','viewnodesuserparams','on','fontsizeuserparams',8);
torsche.graphedit('fit');

%======================================================================

%  slide 1
torsche.graphedit('viewtab',1)

%  slide 2
weight = [7 6 4 3];
cost = [2 3 4 5];
maxWeight = 15;
[usedSubject g] = torsche.knapsack(weight,cost,maxWeight);
torsche.graphedit(g,'viewtab',1,'arrowsvisibility','off')

%  slide 3
g.E(1).Color=[1 0 0];
g.E(1).LineWidth=2;
torsche.graphedit(g,'viewtab',1)

%  slide 4
g.E(4).Color=[1 0 0];
g.E(4).LineWidth=2;
torsche.graphedit(g,'viewtab',1)

%  slide 5
g.E(10).Color=[1 0 0];
g.E(10).LineWidth=2.24;
torsche.graphedit(g,'viewtab',1)

%  slide 6
g.E(29).Color=[1 0 0];
g.E(29).LineWidth=2;
torsche.graphedit(g,'viewtab',1)

%  slide 7
g.E(28).Color=[1 0 0];
g.E(28).LineWidth=2.24;
torsche.graphedit(g,'viewtab',1)




%======================================================================
% slideshow

for i =1:2
    torsche.graphedit('viewtab',i);
    pause(4.0);
end

for i =3:7,
    torsche.graphedit('viewtab',i);
    pause(2.0);
end


disp ('list of used subjects: [2 3 4]');

