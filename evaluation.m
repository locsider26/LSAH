function [score1,score2] = evaluation_common(label_new,gt_target)
% max1=max(max(gt_target));
% max2=lmax(max(label_new));
max1=length(unique(gt_target))-1;
[m,n]=size(gt_target);
gt_class=zeros(max1,m*n,2);
contrast=zeros(max1,m*n);

%���� gt_target�в�ͬԪ�صĸ���,���gt_target(1)ΪԪ��ֵ��gt_target(2)Ϊ��ӦԪ��ֵ���ֵĴ���
 c_gt_target=tabulate(gt_target(:));

%Ѱ��ÿһ��gt����Ԫ�ض�Ӧ��label_new��Ԫ��
for i=1:1:max1
    t=1;
    for j=1:1:m
        for k=1:1:n
            if gt_target(j,k)==i
                contrast(i,t)=label_new(j,k);
%                 gt_class(i,t,:)=[j,k];
                 t=t+1;
            end
        end
    end   
end

%���� gt_target�в�ͬԪ�صĸ���,���gt_target(1)ΪԪ��ֵ��gt_target(2)Ϊ��ӦԪ��ֵ���ֵĴ���
% x1=sort(gt_target);
% d1=diff([x1;max(x1)+1]);
% % count2=diff(find([1,d1]));
% aaa=ones(m,n);
% count2=diff(find([aaa,d1]));
% c_gt_target=[x1(find(d1));count2];���ϴ�����Դ���磬������


%����label_new�в�ͬԪ�صĸ���,���label_new(1)ΪԪ��ֵ��label_new(2)Ϊ��ӦԪ��ֵ���ֵĴ���
%��һ����Ϊ0�����Ӧ�Ĵ���
% x2=sort(reshape(label_new,1,m1*n1));
% d2=diff([x2;max(x2)+1]);
% count2=diff(find([1;d2]));
% c_label_new=[x2(find(d2)),count2];
c_label_new=tabulate(label_new(:));

%���� contrast�в�ͬԪ�صĸ���,���label_new(1)ΪԪ��ֵ��label_new(2)Ϊ��ӦԪ��ֵ���ֵĴ���
% for i=1:1:max1
% eval(['X',num2str(i),'=sort( contrast(i,:));'])
% eval(['D',num2str(i),'=diff([Xi;max(Xi)+1]);'])
% eval(['Count=diff(find([1;D',num2str(i),']));'])
% eval(['c_contrast',num2str(i),'=[X(find(Di)),Count];'])
% end
for i=1:1:max1
    eval(['c_contrast',num2str(i),'=tabulate(contrast(i,:));']);
end
for i=1:1:max1
    eval(['TEST=c_contrast',num2str(i),'(1,1);']);
    if TEST==0
        eval(['c_contrast',num2str(i),'(1,:)=[];']);
    end
end
        

%����ÿһ�����Ӧ�����OIֵ
a=zeros(1,max1);
for i=1:1:max1
eval(['a(1,i)=size(c_contrast',num2str(i),',1);'])
end

for i=1:1:max1
%     for j=2:1:(a(1,i))
    for j=1:1:(a(1,i))
        eval(['t1(i,j)=c_contrast',num2str(i),'(j,2);']);
        %��Ϊ��1 ��gtͼ��û�з�label�� ����Ҫ��ȥ
        t2(i,j)=c_gt_target(i+1,2);
        T=eval(['c_contrast',num2str(i),'(j,1);']);
        if c_label_new(1,1)==0
            T=T+1;
        else
            T=T;
        end
        t3(i,j)=c_label_new(T,2);
        OI(i,j)=t1(i,j)^2/(t2(i,j)*t3(i,j));      
    end
end
OI_max=zeros(max1,1);
index=zeros(max1,1);
for i=1:1:max1
  [OI_max(i,1),index(i,1)]=max(OI(i,:));
end
%���OIֵ��Ӧ�ֿ��QRֵ,���ҵ����
for i=1:1:max1
eval(['label_f(i)=c_contrast',num2str(i),'(index(i,1),1);']);
end

 for i=1:1:max1 
    eval(['QR1(1,i)=c_contrast',num2str(i),'(index(i),2);']); 
%��Ϊ��1 ��gtͼ��û�з�label�� ����Ҫ��ȥ
    QR2(1,i)=c_gt_target(i+1,2);
    %���޸� QR3(1,i)=c_label_new(label_f(i),2);
        if c_label_new(1,1)==0
            label_f(i)=label_f(i)+1;
        else
            label_f(i)=label_f(i);
        end
    QR3(1,i)=c_label_new(label_f(i),2);
    QR(1,i)=1-QR1(1,i)/(QR2(1,i)+QR3(1,i)-QR1(1,i));  
 end
 score1=mean(QR,2);
 for i=1:1:max1
    if find(unique(contrast(i,:))==0)
        S(i)=length(unique(contrast(i,:)))-1;
    else
        S(i)=length(unique(contrast(i,:)));
    end
 end
for i=1:1:max1 
    QRS(i)=QR(i)*S(i);
end
score2=sum(QRS,2)/sum(S,2);
end