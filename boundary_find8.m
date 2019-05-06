function [label]=boundary_find8(varargin)
%ws 8连通区域的边界寻找
label=cell2mat(varargin(1));
a=cell2mat(varargin(2));
b=cell2mat(varargin(3));
nhood=cell2mat(varargin(4));
%需要输入label、待合并label区域a、b，以及搜索范围nhood
[m,n]=size(label);
hood=floor(nhood/2);
extenda= zeros(size(label)+nhood-1);
extenda(1,:)=NaN;
extenda(m+nhood-1,:)=NaN;
extenda(:,1)=NaN;
extenda(:,n+nhood-1)=NaN;
extenda(2:1:m+nhood-2,2:1:n+nhood-2)=label;
[l1x,l1y]=find(extenda==a);
[l2x,l2y]=find(extenda==b);
q1=1;
% 8连通区域
for i=1:1:length(l1x)
        for j=(l1x(i)-hood):1:(l1x(i)+hood)
            for k=(l1y(i)-hood):1:(l1y(i)+hood)
              if(extenda(j,k)==0)
                boundaryx1(q1)=j;
                bouadaryy1(q1)=k;
                q1=q1+1;
              end
            end
        end
end
if q1==1
    boundaryx1=[];
    bouadaryy1=[];
end
        
q2=1;
for i=1:1:length(l2x)
        for j=l2x(i)-hood:1:l2x(i)+hood
            for k=l2y(i)-hood:1:l2y(i)+hood
              if(extenda(j,k)==0)
                boundaryx2(q2)=j;
                bouadaryy2(q2)=k;
                q2=q2+1;
              end
            end
        end
end
if q2==1
    boundaryx2=[];
    bouadaryy2=[];
end
boundaryx1T=boundaryx1';
boundaryy1T=bouadaryy1';
A1=table(boundaryx1T,boundaryy1T);
uA1=unique(A1);
boundaryx1T=boundaryx2';
boundaryy1T=bouadaryy2';
A2=table(boundaryx1T,boundaryy1T);
uA2=unique(A2);
[C,ia,~]=intersect(uA1,uA2);
for i=1:1:length(ia)
    label(C.boundaryx1T(i)-hood,C.boundaryy1T(i)-hood)=a;
end




      
            
            