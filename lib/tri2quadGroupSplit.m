function [varargout]=tri2quadGroupSplit(varargin)

% function [F_quad,V_quad,F_tri,V_tri]=tri2quadGroupSplit(F_tri,V_tri,optionStruct)

%% Parse input

switch nargin
    case 2
        F_tri=varargin{1};
        V_tri=varargin{2};
        optionStruct=[];
    case 3
        F_tri=varargin{1};
        V_tri=varargin{2};
        optionStruct=varargin{3};
end

%Check optionStruct against default
defaultOptionStruct.maxAngleDeviation=45*(pi/180);
defaultOptionStruct.selectionMethod='best'; %'Random'
defaultOptionStruct.triangleConvert=1;
defaultOptionStruct.fourConnectConvert=1;
[optionStruct]=structComplete(optionStruct,defaultOptionStruct,1); %Complement provided with default if missing or empty

maxAngleDeviation=optionStruct.maxAngleDeviation;
selectionMethod=optionStruct.selectionMethod;
triangleConvert=optionStruct.triangleConvert;
fourConnectConvert=optionStruct.fourConnectConvert;

%%

if fourConnectConvert

    [C]=patchConnectivity(F_tri,V_tri);
    EV=C.edge.vertex;
    EF=C.edge.face;

    %Get logic for boundary membership
    Eb=patchBoundary(F_tri,V_tri);
    ind_V_all=(1:1:size(V_tri,1))';
    logicBoundary=ismember(ind_V_all,Eb);
    
    %Count point connectivity
    IND_V=C.vertex.vertex;
    numFriends=sum(IND_V>0,2); %Number of vertex neighbours
    logicFour=numFriends==4; %Logic for vertices with only 4 connected neighbours
    
    %Make sure four connected points are not shared in potential quads
    indFour=find(logicFour);
    logicEdgeFourConnect=all(ismember(EV,indFour),2);
    indEdgeFourConnect=EV(logicEdgeFourConnect,:);    
    logicFour(indEdgeFourConnect(:,1))=0;

    %Remove boundary points from logic    
    logicFour(logicBoundary)=0;
    
    if any(logicFour)
        
        logicSkip=any(logicFour(EV),2);
        EV(logicSkip,:)=0;
        EF(logicSkip,:)=0;
        
        FQc=IND_V(logicFour,1:4);
        
        A1=min(patchEdgeAngles(FQc,V_tri),[],2);
        A2=min(patchEdgeAngles(FQc(:,[1 2 4 3]),V_tri),[],2);
        logicReorder=A2>A1;
        FQc(logicReorder,:)=FQc(logicReorder,[1 2 4 3]);
        
        A1=min(patchEdgeAngles(FQc,V_tri),[],2);
        A2=min(patchEdgeAngles(FQc(:,[1 3 2 4]),V_tri),[],2);
        logicReorder=A2>A1;
        FQc(logicReorder,:)=FQc(logicReorder,[1 3 2 4]);
        
        [N,~,~]=patchNormal(FQc,V_tri);
        [~,~,Nv]=patchNormal(F_tri,V_tri);
        Nv=Nv(logicFour,:);
        
        logicFlip=dot(N,Nv,2)<0;
        FQc(logicFlip,:)=fliplr(FQc(logicFlip,:));
        
        F_tri=F_tri(~any(logicFour(F_tri),2),:);
    else
        FQc=[];
    end
    
end

if ~isempty(F_tri)
    [C]=patchConnectivity(F_tri,V_tri);
    EV=C.edge.vertex;
    EF=C.edge.face;
    
    [~,~,NV_tri]=patchNormal(F_tri,V_tri);
    
    logicValid=all(EF>0,2);
    EF=EF(logicValid,:);
    EV=EV(logicValid,:);
    
    FS=[F_tri(EF(:,1),:) F_tri(EF(:,2),:)];
    
    I=(1:1:size(EV,1))';
    I=I(:,ones(1,6));
    I=I(:);
    
    S=sparse(I,FS,1,size(EV,1),size(V_tri,1),numel(FS))>0;
    [~,J]=find(S);
    S=double(S);
    S(S>0)=J;
    S=sort(S,2,'descend');
    S=full(S(:,1:4));
    S(S==EV(:,1*ones(1,size(S,2))))=0;
    S(S==EV(:,2*ones(1,size(S,2))))=0;
    S=sort(S,2,'descend');
    FQ=[S(:,1) EV(:,1) S(:,2) EV(:,2)];
    
    [NQ]=patchNormal(FQ,V_tri);
    [NV_tri_FQ]=vertexToFaceMeasure(FQ,NV_tri);
    NV_tri_FQ=vecnormalize(NV_tri_FQ);
    logicFlip=dot(NV_tri_FQ,NQ,2)<0;
    FQ(logicFlip,:)=fliplr(FQ(logicFlip,:));
    
    A=patchEdgeAngles(FQ,V_tri);
    A(any(abs(abs(A)-(pi/2))>maxAngleDeviation,2),:)=NaN;
    F_quad_sub=[];
    c=1;
    while 1
        switch selectionMethod
            case 'best'
                [~,indMin]=min(sum(abs(A-(pi/2)),2));
            case 'random'
                indPick=find(all(~isnan(A),2));
                indRand=randperm(numel(indPick));
                indMin=indPick(indRand(1));
        end
        A(indMin)=NaN;
        fq_now= FQ(indMin,:);
        F_quad_sub=[F_quad_sub; fq_now;];
        logicRemove=sum(ismember(FQ,fq_now),2)>2;
        A(logicRemove,:)=NaN;
        if nnz(isnan(A))==numel(A)
            break
        end
        c=c+1;
    end
    
    F_quad_sub_tri=[F_quad_sub(:,[1 2 3]); F_quad_sub(:,[3 4 1]); F_quad_sub(:,[1 2 4]); F_quad_sub(:,[2 3 4]);];
    
    virtualInd_F_tri=sub2indn(size(V_tri,1)*ones(1,3),sort(F_tri,2));
    virtualInd_F_quad_sub_tri=sub2indn(size(V_tri,1)*ones(1,3),sort(F_quad_sub_tri,2));
    
    logicRemove=ismember(virtualInd_F_tri,virtualInd_F_quad_sub_tri);
    F_tri=F_tri(~logicRemove,:);
    
    F_quad=F_quad_sub;
    if fourConnectConvert
        F_quad=[F_quad;FQc];
    end
    V_quad=V_tri;
    
    if ~isempty(F_tri)
        if triangleConvert==1
            [F_quad_sub,V_quad_sub]=subQuad(F_quad,V_quad,1);
            [F_quad2,V_quad2]=tri2quad(F_tri,V_tri);
            [F_quad,V_quad]=joinElementSets({F_quad_sub,F_quad2},{V_quad_sub,V_quad2});
            [F_quad,V_quad]=patchCleanUnused(F_quad,V_quad);
            [F_quad,V_quad]=mergeVertices(F_quad,V_quad);
        else
            [F_quad,V_quad]=patchCleanUnused(F_quad,V_quad);
            [F_tri,V_tri]=patchCleanUnused(F_tri,V_tri);
        end
    end
    %% Collect output
    
    varargout{1}=F_quad;
    varargout{2}=V_quad;
    varargout{3}=F_tri;
    varargout{4}=V_tri;
    
else
    
    %% Collect output
    
    varargout{1}=FQc;
    varargout{2}=V_tri;
    varargout{3}=[];
    varargout{4}=[];
    
end



