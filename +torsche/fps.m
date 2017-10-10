function resultts = fps(ts, varargin)
%FPS  Schedules periodic tasks in taskset T according to their
%   fixed priorities (property Weight of a task).
%
% Synopsis
%           TS = fps(T[,keyword1,value1[,keyword2,value2[...]]])
%
% Description
%  Properties:
%   TS:
%     - task set to be scheduled
%   keyword:
%     - configuration parameters for plot style
%   value:
%     - configuration value
%
%  Available keywords:
%   Hyperperiod:
%     - hyperperiod to be considered (default is LCM of the task periods)
%   StopWhenIdle:
%     - stop scheduling when the processor is idle (default is 0)
%
%	TS = fps(T) adds schedule to the set of tasks, T -
%	input set of tasks, TS - set of tasks with a schedule
%
% See also: PTASK

% Author: Michal Sojka <sojkam1@fel.cvut.cz>
% Originator: Michal Kutil <kutilm@fel.cvut.cz>
% Originator: Premysl Sucha <suchap@fel.cvut.cz>
% Project Responsible: Zdenek Hanzalek
% Department of Control Engineering
% FEE CTU in Prague, Czech Republic
% Copyright (c) 2004 - 2009 
% $Revision: 2895 $  $Date:: 2009-03-18 11:24:58 +0100 #$

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


ni = length(varargin);
if ni == 1 && iscell(varargin{1})
    varargin = varargin{1};
    ni = length(varargin);
elseif mod(ni,2) == 1
    error('Invalid count of input parameters.');
end

% default values
tstop = -1;
stop_when_idle = 0;

i=1;
while i <= ni,
    switch lower(varargin{i})
        case 'hyperperiod'
            tstop=varargin{i+1};
        case 'stopwhenidle'
            stop_when_idle = logical(varargin{i+1});

        otherwise
            error(['Unknown parameter: ',varargin{i}]);
    end
    i=i+2;
end

resultts = [];

c    =  ts.ProcTime;
per  =  ts.Period;
prio =  ts.Weight;

noft=size(c,2);

%initialization
ready = zeros(size(c));

schedtask=-1;
tmax=0;% time of scheduler

%ts=colour(ts); TODO - colorize only tasks with no color specified

% compute length of hyper-period if not given as parameter
if tstop < 0
    tstop = 1;
    for i = 1:noft
        tstop = lcm(tstop, per(i));
    end
end

% Procedure to add to the ready queue all tasks released at time t.
function add_to_ready(t)
    offs = mod(t, per);
    for j=1:noft
        if (offs(j) == 0)
            ready(j)=c(j); % put the tasks to the ready set
            pt = ts.tasks(j);
            pts = struct(pt);
            temptask = pts.parent;
            temptask.Processor = j; % Hack for plotting the schedule
            temptask.ReleaseTime = t;
            temptask.Deadline = temptask.Deadline + t;
            readyTasks{j} = temptask;
        end
    end
end

while(tmax < tstop)

    add_to_ready(tmax);
    
    schedtask=-1; %  -1 means the idle task
    maxprio=1;
    for i=1:noft
        if(((ready(i)~=0))&&((maxprio<=prio(i))))
            maxprio=prio(i);
            schedtask=i;
        end
    end
    
    % Find the ready task with maximum priority
    
     hp_ind = find(prio > prio(schedtask));
     % find the closest time, where somebody can preempt schedtask
     a = per(hp_ind)-mod(tmax, per(hp_ind)); 
     astar = min(a);
     
     [start, len, processor] = get_scht(readyTasks{schedtask});
     start = [start tmax];
     processor = [processor readyTasks{schedtask}.Processor]; % Hack for plotting the schedule
     if astar < ready(schedtask) % the task is preempted
        len = [len astar];
        readyTasks{schedtask} = add_scht(readyTasks{schedtask}, start, len, processor);
        ready(schedtask)= ready(schedtask)-astar; 
        tmax=tmax+astar;
     else % the whole task will be executed
        executed = ready(schedtask);
        len = [len executed];
        readyTasks{schedtask} = add_scht(readyTasks{schedtask}, start, len, processor);
        ready(schedtask)= 0;
        
        % check for tasks released during the execution time
        for t = tmax + 1 : tmax + executed - 1
            add_to_ready(t);
        end
        
        if any(ready)
            tmax = tmax + executed;
        else
            tmax = tmax + astar;
        end
        if isempty(resultts)
            resultts = [readyTasks{schedtask}];
        else
            resultts = [resultts readyTasks{schedtask}];
        end
     end
     
     % end the scheduling if the processor is idle, if 
     if sum(ready) == 0 && stop_when_idle
         break
     end
end
add_schedule(resultts, 'Fixed priority schedule');

end