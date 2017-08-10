function [Xc,Yc,Zc]=im2MRcartNeg(I,J,K,v,OR,rn,cn)

%--------------------------------------------------------------------------
% function [X,Y,Z]=im2MRcart(I,J,K,v,OR,r,c)
% 
% This function calculates the cartesian coordinates X,Y,Z of the image
% coordinates I,J,K based on the voxel dimensions v, the origin OR (cartesian
% coorindates of the point I=1, J=1, K=1), the offsets r anc c.
%
% v=N_info.PixelSpacing;
% v(3)=N_info.SliceThickness;

% ORIGIN:
% The x, y, and z coordinates of the upper left hand corner (center of the
% first voxel transmitted) of the image, in mm. 
% OR=N_info.ImagePositionPatient; 

% ROW DIRECTION
% r=N_info.ImageOrientationPatient(4:6);

% COLUMN DIRECTION
% c=N_info.ImageOrientationPatient(1:3);
%
% Based on:
% http://cmic.cs.ucl.ac.uk/fileadmin/cmic/Documents/DavidAtkinson/DICOM_6up.pdf
% and the file "TranTransform matrix between two dicom image coordinates"
% from the matlab central file exchange written by Alper Yaman. 
%-------------------------------------------------------------------------- 

reForm=~isvector(I); 

size_M=size(I);

% r => row direction vector
r=vecnormalize(cn);

% c => column direction vector
c=vecnormalize(rn);

%Determine s => slice direction 
s=cross(c',r'); %Determine s => slice direction vector
s=vecnormalize(s);

I=(I(:)-1)';J=(J(:)-1)';K=(K(:)-1)'; %Shift so first voxel is at 0 0 0

%Translation
T  = [1 0 0 OR(1);...
      0 1 0 OR(2);...
      0 0 1 OR(3);...
      0 0 0 1]; 
%Rotation
R  = [r(1) c(1) s(1) 0;...
      r(2) c(2) s(2) 0;...
      r(3) c(3) s(3) 0;...
      0    0    0    1];
%Scaling  
S  = [v(1) 0    0    0;...
      0    v(2) 0    0;...
      0    0    v(3) 0;...
      0    0    0    1];
  
T0 = eye(size(T));

M  = T * R * S * T0; %The transformation matrix

IJK=ones(4,length(I));
IJK(1,:)=I;
IJK(2,:)=J;
IJK(3,:)=K;
IJK=double(IJK);

XYZ=(M*IJK)';

X=XYZ(:,1); Y=XYZ(:,2); Z=XYZ(:,3);

if reForm %If the input is not a vector reshape
    X=reshape(X,size_M);
    Y=reshape(Y,size_M);
    Z=reshape(Z,size_M);
end

%Switch convention
Xc=Y; Yc=X; Zc=Z;


 
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
