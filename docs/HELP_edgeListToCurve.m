%% edgeListToCurve
% Below is a basic demonstration of the features of the |edgeListToCurve| function.

%% 

clear; close all; clc;

%% CREATING A REGION MESH

% Creating boundary curves 

%Boundary 1
ns=150;
t=linspace(0,2*pi,ns);
t=t(1:end-1);
r=6+2.*sin(5*t);
[x,y] = pol2cart(t,r);
V1=[x(:) y(:)];

%Boundary 2
[x,y] = pol2cart(t,ones(size(t)));
V2=[x(:) y(:)+4];

%Boundary 3
[x,y] = pol2cart(t,2*ones(size(t)));
V3=[x(:) y(:)-0.5];

%Defining a region
regionCell={V1,V2,V3}; %A region between V1 and V2 (V2 forms a hole inside V1)

plotOn=1; %This turns on/off plotting

%Desired point spacing
pointSpacing=0.5; 

[F,V]=regionTriMesh2D(regionCell,pointSpacing,1,0);

%%
cFigure; hold on; 
gpatch(F,V,'g');

axisGeom; view(2);
drawnow;

%%
E=patchBoundary(F,V);
% E=E(all(ismember(E,find(V(:,1)<4.15)),2),:);


% [indList]=edgeListToCurve(E);
[G,G_iter]=tesgroup(E);

for q=1:1:size(G,2)
        
    E_now=E(G(:,q),:);

    plotV(V(E_now,:),'b.','markersize',25);


    [indListNow]=edgeListToCurve(E_now);
    
    plotV(V(indListNow,:),'b.-','markersize',25,'lineWidt',5);
    for w=1:1:numel(indListNow)
        plotV(V(indListNow(w),:),'r.','markersize',25);
        drawnow;
    end
    
end

%% 
%
% <<gibbVerySmall.gif>>
% 
% _*GIBBON*_ 
% <www.gibboncode.org>
% 
% _Kevin Mattheus Moerman_, <gibbon.toolbox@gmail.com>
