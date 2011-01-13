function [fp1] = stripheader(fp1,a);

if (a==1)
   fread(fp1,32,'char*1');
end

if (a==2)
   fread(fp1,28,'char*1');
end

if (a==3) % siemens mda files
    fread(fp1,20,'char*1');
end


if (a==4) % Siemens variable length header
    skip = fread(fp1,1,'long');
    fread(fp1,skip-4,'char*1');
end

if (a==5)
    fread(fp1,128,'char*1');
end
    