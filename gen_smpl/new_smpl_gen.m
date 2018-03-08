clc
clear all
pth='./smpl';
mkdir(pth)
r=50.00001;
dim=1000;
md=[9.5 10.35 10.8 11.45 11.95];
n=[100 80 70 60 50];
for i=1:length(md)
   for j=1:20
       [a,kk]=gensmpl(r,n(i),md(i),dim);
       dlmwrite(strcat(pth,'/',num2str(i),'-',num2str(j),'.dat'),a, 'delimiter', ',', 'precision', 5); 
   end
   clc
   fprintf('%d done\n',i)
end
