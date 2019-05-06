clear all; close all; clc
dbstop if error
 profile clear
 profile on;

load Rural_T1.mat
x=subhill1;
load Rural_label_T1.mat
x1=labelGT;
X=[];
[m,n,L]=size(x);
for i=1:1:L
    X(i,:,:)=x(:,:,i);
end
x=X; 
test1=max(max(x1));
test2=unique(x1);
test3=length(test2);
TTT=0;
TT=ones(m,n);
if test1~=(test3-1)
 for i=1:1:test1
    if  isempty(find(x1==(i-TTT), 1))
        x1=x1.*(x1>(i-TTT))-TT.*(x1>(i-TTT))+x1.*(x1<(i-TTT));
        TTT=TTT+1;
    end                 
 end 
end
                                      
cm1=1;cm=m;
cn1=1;cn=n;
cut=zeros(L,(cm-cm1+1),(cn-cn1+1));
for i=cm1:1:cm
    for j=cn1:1:cn
       cut(:,(i-cm1+1),(j-cn1+1)) =x(:,i,j);
    end
end
MAX=max(max(max(x)));
cut=cut/MAX;

X_gradient=mywindow(cut,[L,3,3],'sliding',@SAD1);
X_gradient=X_gradient/pi*180;
label1=watershed(X_gradient,4);
test1=max(max(label1));
test2=unique(label1);
test3=length(label1);
TTT=0;
TT=ones(m,n);
if test1~=(test3-1)
  for i=1:1:test1
    if  isempty(find(label1==(i-TTT), 1))
        label1=label1.*(label1>(i-TTT))-TT.*(label1>(i-TTT))+label1.*(label1<(i-TTT));
        TTT=TTT+1;
    end                 
  end                  
end


start=1;
ended=10;
for w=start:1:ended
thita_base=w;
K=0;
N=length(unique(label1));
label_circulation=label1;

cir_num=N;
nhood=3;
K2=0;
TT=ones(m,n);
H=Local_SAH_new(label_circulation,cut);
for o=1:1:cir_num
       K1=length(unique(label_circulation));
       % GSA
       [label_new]=GSA(label_circulation,cut,thita_base);
%        % LSA
%        [label_new]=LSA(label_circulation,cut,thita_base,H);
%        %LSAH
%        [label_new]=LSAH(label_circulation,cut,thita_base,H);
       
       TTT=0;
       for i=1:1:max(max(label_new))
               if  isempty(find(label_new==(i-TTT), 1))
                    label_new=label_new.*(label_new>(i-TTT))-TT.*(label_new>(i-TTT))+label_new.*(label_new<(i-TTT));
                   TTT=TTT+1;
               end                 
       end
       K2=length(unique(label_new));
       if K2<K1
           label_circulation=label_new;
       elseif K2==K1
          break
       end
end
[score1{w},score2{w},score3{w}]=evaluation(label_new,x1);
avg_score1(w)=mean(score1{w},2);
avg_score2(w)=mean(score2{w},2);
avg_score3(w)=mean(score3{w},2);
end





