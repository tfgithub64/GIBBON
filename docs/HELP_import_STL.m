%% import_STL
% Below is a demonstration of the features of the |import_STL| function

%% Syntax
% |[stlStruct] = import_STL(fileName);|

%% Description
% Use |import_STL| to import binary or txt type STL files.

%% Examples

clear; close all; clc;

%%
% Plot settings
fontSize=25; 

%% Import a txt type STL file as patch data

%Set main folder
defaultFolder = fileparts(fileparts(mfilename('fullpath')));
pathName=fullfile(defaultFolder,'data','STL'); 
fileName=fullfile(pathName,'femur.stl'); 
[stlStruct] = import_STL(fileName);

F=stlStruct.solidFaces{1};
V=stlStruct.solidVertices{1};

%%
% Merging nodes example
[~,ind1,ind2]=unique(pround(V,5),'rows');
V=V(ind1,:);
F=ind2(F);

%%
% Plotting the model

cFigure;
title('Imported patch data from STL','fontSize',fontSize);
gpatch(F,V,'g');
axisGeom;
camlight('headlight');
lighting phong; axis off; 
drawnow;

%% Import a binary type STL file as patch data

%Set main folder
defaultFolder = fileparts(fileparts(mfilename('fullpath')));
pathName=fullfile(defaultFolder,'data','STL'); 
fileName=fullfile(pathName,'femur_bin.stl'); 
[stlStruct] = import_STL(fileName);

F=stlStruct.solidFaces{1};
V=stlStruct.solidVertices{1};

%%
% Merging nodes example
[~,ind1,ind2]=unique(pround(V,5),'rows');
V=V(ind1,:);
F=ind2(F);

%%
% Plotting the model

cFigure;
title('Imported patch data from STL','fontSize',fontSize);
gpatch(F,V,'g');
axisGeom;
camlight('headlight');
lighting phong; axis off; 
drawnow;

%% 
%
% <<gibbVerySmall.gif>>
% 
% _*GIBBON*_ 
% <www.gibboncode.org>
% 
% _Kevin Mattheus Moerman_, <gibbon.toolbox@gmail.com>
 
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
