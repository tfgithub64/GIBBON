function cMap=wcbp(varargin)

switch nargin
    case 0
        n=250;
    case 1
        n=varargin{1};
end

cPink=[220 000 163];
cBlue=[0 0 204];
cCyan=[0 160 160];

cMap=[255*ones(1,3);... 
    120*ones(1,3);...
    cCyan;...
    cBlue;...
    cPink/1.5;...
    cPink;]./255;

[cMap]=resampleColormap(cMap,n);
 
%% <-- GIBBON footer text --> 
% Copyright 2017 Kevin Mattheus Moerman
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%   http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
