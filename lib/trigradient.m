function [ux,uy]=trigradient(TRI,V,INT)

%Equivalent to [ux,uy]=pdegrad(V',TRI',INT);


% Point indices
IND_1=TRI(:,1); IND_2=TRI(:,2); IND_3=TRI(:,3);

% Triangle sides
r23x=V(IND_3,1)-V(IND_2,1); 
r31x=V(IND_1,1)-V(IND_3,1);
r12x=V(IND_2,1)-V(IND_1,1);

r23y=V(IND_3,2)-V(IND_2,2);
r31y=V(IND_1,2)-V(IND_3,2);
r12y=V(IND_2,2)-V(IND_1,2);

ar=abs(r31x.*r23y-r31y.*r23x)/2;

g1x=-0.5*r23y./ar;
g2x=-0.5*r31y./ar;
g3x=-0.5*r12y./ar;

g1y=0.5*r23x./ar;
g2y=0.5*r31x./ar;
g3y=0.5*r12x./ar;

ux=INT(IND_1,:).*g1x + INT(IND_2,:).*g2x + INT(IND_3,:).*g3x ;
uy=INT(IND_1,:).*g1y + INT(IND_2,:).*g2y + INT(IND_3,:).*g3y;

end
 
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
