function [docNode]=addModuleComponents_FEB(docNode,moduleNode,FEB_struct)

%Check for parameters or use default
if ~isfield(FEB_struct,'Module')
    %Add defaults
    FEB_struct.Module.Type='solid';
end

attr = docNode.createAttribute('type'); %Create attribute
attr.setNodeValue(FEB_struct.Module.Type); %Set text
moduleNode.setAttributeNode(attr); %Add attribute

 
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
