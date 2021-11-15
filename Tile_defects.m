clc;
close all;
clear all ;
I=imread('m_perfect.png');
if size(I,3)>1
    T1=0;
a1=mean(mean(I));
for i=1:3
    T1=T1+a1(i);
end
T1=T1/3;
    I=rgb2gray(I);
end
I=imresize(I,[256,256]);
I=double(I);
edge = edge(I,'canny'); %edge detection
y2=im2bw(edge,0.5);     %binary
s=bwmorph(y2,'bridge');   %morphological operation
f=strel('line',2,7);
s1=imdilate(s,f);
%s1=imfill(s1,[1,1],26);
[x,y]=size(s1);
 countC=0; countA=0;
  for i=1:x
     for j=1:y
      if s1(i,j)==1
         countC=countC+1; %reference: white pixels of filled image
      end
     end
   end
[p,q]=size(y2);
for i=1:p
    for j=1:q
        if y2(i,j)==1
            countA=countA+1;  %reference: white pixels of edge image
        end
    end
end
figure;
subplot(1,2,1);
imshow(y2);
title('edge detected perfect tile');
subplot(1,2,2); 
imshow(s1);
title('filled perfect tile');
Th=2000;
Id=imread('m_edge_defect.png'); 
if size(Id,3)>1
    T2=0;
a2 = mean(mean(Id));
for j=1:3
    T2=T2+a2(j);
end
T2=T2/3;
  Id=rgb2gray(Id);    
end
[countB,countD]=B_edgeOfDefect(Id);
m=0;
if (abs(a2-a1))>10
    msgbox('color defected tile');
    m=2;
end
if ((countB-countA)/100)>1 
    if countD>Th && m~=2
  msgbox('Middle crack detected');
  m=1;
    end
end
if ((countD-countC)/100)>1 
    if countD<Th && (countD-countC)>(countB-countA) && m~=2
  msgbox('Edge/Corner crack detected');
  m=1;
    end
end
if m==0
    msgbox('Perfect tile');
end

