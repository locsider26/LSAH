 function [label_new]=LSA(varargin)
label=cell2mat(varargin(1));
image=cell2mat(varargin(2));
thita_base=cell2mat(varargin(3));
H1_estimate=cell2mat(varargin(4));

label=double(label);
[l,m1,n1]=size(image);
[~,d,boundary]=imRAG(label,1);
d1=d(:,1);
d2=d(:,2);
U=unique(d1);
N2=length(U);
AMU=zeros(1,l);
for i=1:1:N2
    J1=d2(d1==U(i));
    J2=d1(d2==U(i));
    J=[J1',J2'];
    LJ=length(J); 
    AM=zeros(LJ,l); 
    thita=180*ones(1,LJ);
    for j=1:1:LJ
      for k=1:1:l       
      test=reshape(image(k,:,:),[m1,n1]).*(label==J(j));
      AM(j,k)=mean(test(test~=0));
      test=reshape(image(k,:,:),[m1,n1]).*(label==U(i));   
      AMU(k)=mean(test(test~=0));
      end
      thita(j)=acos(sum( AMU.*AM(j,:),2)./sqrt(sum((AMU).^2,2)*sum(AM(j,:).^2,2)))/pi*180;
    end
    [thita1k,lk]=min(thita);
    AT=std(mean(image(:,(label==U(i)))),0,2);
    if thita1k<=thita_base/(AT/H1_estimate);
           if U(i)<J(lk)
        order= d1==U(i)&d2==J(lk);
        label(boundary{order})=U(i);
        label(label==J(lk))=U(i);
        label_new=label;
           else
          order= d1==J(lk)&d2==U(i); 
          label(boundary{order})=U(i);
        label(label==J(lk))=U(i);
        label_new=label;
           end
          return        
    end
label_new=label;   
end
end
