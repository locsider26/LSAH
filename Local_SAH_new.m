function [H]=Local_SAH_new(varargin)
%����ȫ����ֵ
msg = 'Error occurred in mymerge.';
label=cell2mat(varargin(1));
image=cell2mat(varargin(2));
% ����������
[~,m1,n1]=size(image);
if find(label==0)
    N=length(unique(label))-1;
else
    N=length(unique(label));
end
%�����������ˮ��
 for i=1:1:N
     A(i)=std(mean(image(:,(label==i)),1),0,2);
     HA(i)=length(find(label==i))*A(i);
 end 
H=sum(HA,2)/length(find(label~=0));

%���������ˮ��
% for i=1:1:N+1
%      A(i)=std(mean(image(:,(label==(i-1))),1),0,2);
%      HA(i)=length(find(label==(i-1)))*A(i);
% end
% H=sum(HA,2)/m1*n1;



% H=sum(HA,2)/(m1*n1);






 
               

       
