function [label_new]=LSAH(varargin)

label=cell2mat(varargin(1));
image=cell2mat(varargin(2));
thita_base=cell2mat(varargin(3));
H1_estimate=cell2mat(varargin(4));

[l,m1,n1]=size(image);
label=double(label);
HS=reshape(mean(image,1),[m1,n1]);
C=[0,1,0;1,1,1;0,1,0];
N=length(unique(label))-any(any(label));
[~,d,boundary]=imRAG(label,1);
d1=d(:,1);
d2=d(:,2);
N1=size(d1,1);
for i=1:1:N
       [a1,b1]=find(imdilate((label==i),C)-(label==i)~=0);       
        B{i}=[a1(:),b1(:)];                                       
end

 HR3=zeros(1,N1);
 SHR3=zeros(1,N1);
 HR=zeros(1,N1);
 SHR=zeros(1,N1);
 for i=1:1:N1
   T{i,1}=intersect(B{d1(i)},B{d2(i)},'rows');
   wait_plus=zeros(m1,n1);
   wait_plus(T{i}(:,1),T{i}(:,2))=1;
   boundary{i}=wait_plus;

   H3{i}=(((label==d1(i))+(label==d2(i))+imdilate(wait_plus,C)+wait_plus)==2); 
   T1{i}=H3{i}.*HS; 
   T1{i}=T1{i}(T1{i}~=0);
   HR3(i)=std(T1{i});
   SHR3(i)=length(T1{i});
   HR(i)=std([HS(label==d1(i))',HS(label==d2(i))',HS(boundary{i}~=0)']);
   SHR(i)=length([HS(label==d1(i))',HS(label==d2(i))',HS(boundary{i}~=0)']);
end

AM=zeros(N,l);
for i=1:1:N
    for j=1:1:l
    test=reshape(image(j,:,:),[m1,n1]).*(label==i);  
    AM(i,j)=mean(test(test~=0));
    end
end

thita=zeros(1,N1);
L_thita=zeros(1,N1);
for i=1:1:N1
    thita(i)=acos(sum(AM(d1(i),:).*AM(d2(i),:),2)./sqrt(sum(AM(d1(i),:).^2,2)*sum(AM(d2(i),:).^2,2)))/pi*180;
    L_thita(i)=thita_base/((SHR(i)/(SHR(i)+SHR3(i)))*HR(i)/H1_estimate+(SHR3(i)/(SHR(i)+SHR3(i)))*HR3(i)/HR(i));
end
   

turn=unique(d1);
lt=length(turn);
TX=zeros(lt,4);
for k=1:1:lt
      [thita1k,lk]=min(thita((d1==turn(k))));
      subset=d2(d1==turn(k));
      subset2=L_thita(d1==turn(k));
      TX(k,:)=[turn(k),subset(lk),thita1k,subset2(lk)];
end
subset4=TX(:,3);
for i=1:1:lt
      subset3=[subset4(TX(:,2)==TX(i,2))',subset4(TX(:,1)==TX(i,2))',subset4(TX(:,2)==i)'];
      subset3(subset3==TX(i,3))=[];
      if isempty(subset3)
        if(TX(i,3)<=TX(i,4))
           label_new=boundary_find4(label,TX(i,1),TX(i,2));
            return
        end
      elseif TX(i,3)< min(subset3)&& (TX(i,3)<=TX(i,4))
          label_new=boundary_find4(label,TX(i,1),TX(i,2));
        return
      end 
end
label_new=label;
end
