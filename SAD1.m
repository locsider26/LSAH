function sad =SAD1(chunk,nhood)
mpad1 = ceil(nhood(2)/2);
npad1 = ceil(nhood(3)/2);
T1=zeros(nhood(2),nhood(3));
T2=zeros(nhood(2),nhood(3));

B=zeros(size(chunk,1),1,1);
if (rem(nhood(2),2)~=0)&&(rem(nhood(3),2)~=0)
    B(:,:)=chunk(:,mpad1,npad1);
else
    B(:,:)=mean(mean(chunk,3),2);
end
B2=B.^2;
B3=sum(B2); 
for k=1:1:nhood(1)
    for i=1:1:nhood(2)
        for j=1:1:nhood(3)            
               t1(i,j)=chunk(k,i,j)*B(k,1);
               t2(i,j)=chunk(k,i,j)^2;
               T1(i,j)=T1(i,j)+t1(i,j); 
               T2(i,j)=T2(i,j)+t2(i,j);
        end
    end
end
for i=1:1:nhood(2)
        for j=1:1:nhood(3)  
            if T2(i,j)==0
                sad1(i,j)=0;
            else
                sad1(i,j)=acos(T1(i,j)/(T2(i,j)*B3)^0.5);
            end
        end
end
sad=max(reshape(sad1,numel(sad1),1));