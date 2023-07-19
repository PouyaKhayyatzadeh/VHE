% str = fileread('CoeffDataPurified2.csv');
% %strnew = strrep(str,'^','10^');
% fid = fopen('Coeff.csv','w');
% fprintf(fid,'%e',str);
% fclose(fid);
% type Coeff.csv
format long g;
Te = 80;

coeff = readtable('CoeffDataPurified2.csv');
Tindex = find(coeff.T==Te)
coeff.mu1(Tindex)

