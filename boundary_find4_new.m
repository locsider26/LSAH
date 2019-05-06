function [label_new]=boundary_find4_new(varargin)
%ws 4连通区域的边界寻找
label_new=cell2mat(varargin(1));
a=cell2mat(varargin(2));
b=cell2mat(varargin(3));
nhood=3;
%需要输入label、待合并label区域a、b，以及搜索范围nhood
[m,n]=size(label_new);
hood=floor(nhood/2);
extenda= zeros(size(label_new)+nhood-1);
extenda(1,:)=NaN;
extenda(m+nhood-1,:)=NaN;
extenda(:,1)=NaN;
extenda(:,n+nhood-1)=NaN;
extenda(2:1:m+nhood-2,2:1:n+nhood-2)=label_new;
[l1x,l1y]=find(extenda==a);
[l2x,l2y]=find(extenda==b);
q1=1;
%8连通区域
% for i=1:1:length(l1x)
%         for j=(l1x(i)-hood):1:(l1x(i)+hood)
%             for k=(l1y(i)-hood):1:(l1y(i)+hood)
%               if(extenda(j,k)==0)
%                 boundaryx1(q1)=j;
%                 bouadaryy1(q1)=k;
%                 q1=q1+1;
%               end
%             end
%         end
% end
% q2=1;
% for i=1:1:length(l2x)
%         for j=l2x(i)-hood:1:l2x(i)+hood
%             for k=l2y(i)-hood:1:l2y(i)+hood
%               if(extenda(j,k)==0)
%                 boundaryx2(q2)=j;
%                 bouadaryy2(q2)=k;
%                 q2=q2+1;
%               end
%             end
%         end
% end
%4连通区域
for i=1:1:length(l1x)
    if (extenda(l1x(i)-hood,l1y(i))==0)
        boundaryx1(q1)=l1x(i)-hood;
        bouadaryy1(q1)=l1y(i);
        q1=q1+1;
    end
    if (extenda(l1x(i),l1y(i)-hood)==0)
        boundaryx1(q1)=l1x(i);
        bouadaryy1(q1)=l1y(i)-hood;
        q1=q1+1;
    end
    if (extenda(l1x(i)+hood,l1y(i))==0)
        boundaryx1(q1)=l1x(i)+hood;
        bouadaryy1(q1)=l1y(i);
        q1=q1+1;
    end
    if (extenda(l1x(i),l1y(i)+hood)==0)
        boundaryx1(q1)=l1x(i);
        bouadaryy1(q1)=l1y(i)+hood;
        q1=q1+1;
    end
end
if q1==1
    boundaryx1=[];
    bouadaryy1=[];
end
        
q2=1;
for i=1:1:length(l2x)
    if (extenda(l2x(i)-hood,l2y(i))==0)
        boundaryx2(q2)=l2x(i)-hood;
        bouadaryy2(q2)=l2y(i);
        q2=q2+1;
    end
    if (extenda(l2x(i),l2y(i)-hood)==0)
        boundaryx2(q2)=l2x(i);
        bouadaryy2(q2)=l2y(i)-hood;
        q2=q2+1;
    end
    if (extenda(l2x(i)+hood,l2y(i))==0)
        boundaryx2(q2)=l2x(i)+hood;
        bouadaryy2(q2)=l2y(i);
        q2=q2+1;
    end
    if (extenda(l2x(i),l2y(i)+hood)==0)
        boundaryx2(q2)=l2x(i);
        bouadaryy2(q2)=l2y(i)+hood;
        q2=q2+1;
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
    extenda(C.boundaryx1T(i),C.boundaryy1T(i))=a;
end
extenda(extenda==b)=a;
%消除单独的0点
% [D,~,~]=union(uA1,uA2);
% E=setdiff(D,C,'rows');
% extenda(1,:)=a;
% extenda(m+nhood-1,:)=a;
% extenda(:,1)=a;
% extenda(:,n+nhood-1)=a;
% for i=1:1:length(E.boundaryx1T)
%     if extenda(E.boundaryx1T(i)-1,E.boundaryy1T(i))==a&& extenda(E.boundaryx1T(i)+1,E.boundaryy1T(i))==a&& extenda(E.boundaryx1T(i),E.boundaryy1T(i)-1)==a&& extenda(E.boundaryx1T(i),E.boundaryy1T(i)+1)==a
%         extenda(E.boundaryx1T(i),E.boundaryy1T(i))=a; 
%     end
% end
label_new=extenda(2:1:m+nhood-2,2:1:n+nhood-2);
% for i=1:1:length(ia)
%     label_new(C.boundaryx1T(i)-hood,C.boundaryy1T(i)-hood)=a;
% end
% label_new(label_new==b)=a;
% [D,~,~]=union(uA1,uA2);
% E=setdiff(D,C,'rows');
% extende= zeros(size(label_new)+nhood-1);
% extende(2:1:m+nhood-2,2:1:n+nhood-2)=label_new;
% for i=1:1:length(E.boundaryx1T)
%     if label_new(E.boundaryx1T(i)-hood-1,E.boundaryy1T(i)-hood)==0&& label_new(E.boundaryx1T(i)-hood+1,E.boundaryy1T(i)-hood)==0&& label_new(E.boundaryx1T(i)-hood,E.boundaryy1T(i)-hood-1)==0&& label_new(E.boundaryx1T(i)-hood,E.boundaryy1T(i)-hood+1)==0
%         label_new(E.boundaryx1T(i)-hood,E.boundaryy1T(i)-hood)=a; 
%     end
% end

%将合并区域的内部边界差集中的点赋值（测试）
% [D,~,~]=union(uA1,uA2);
% E=setdiff(D,C,'rows');
% [bx,by]=find(label_new==a);
% in=inpolygon(E.boundaryx1T,E.boundaryy1T,bx+1,by+1);
% for i=1:1:size(E,1)
%     if in(i)~=0
%         label_new(E.boundaryx1T(i)-hood,E.boundaryy1T(i)-hood)=a;
%     end
% end
%
end




      
            
            