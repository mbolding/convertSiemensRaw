function [data]=ReadImages1(fp1,imagetype)

working_directory = cd;
eh = findobj(gcf,'Tag','BaseDirectory');
start_path = get(eh,'String');
start_path2 = strcat(start_path,'/B0Maps');
start_path3 = strcat(start_path,'/Scout.fid');


switch(imagetype)
    case 1 % B0 images
        eh = findobj(gcf,'Tag','VarianFile1');
        dir = get(eh,'String');
        
    case 2
        
        eh = findobj(gcf,'Tag','ScoutImageName');
        dir = get(eh,'String');
end


[reads,res,rcvrs,slices,B0s,oversample] = GetInformation(imagetype);
totreads = 2*reads;
pevalues = zeros(1,res);
data = zeros(totreads,res,rcvrs,slices,B0s);


eh = findobj(gcf,'Tag','EncodeTable');
encodetable = get(eh,'Value');

if (encodetable==1)
    
    textstring='npe1';
    npe1 = GetFromProcpar(dir,textstring);
    textstring='npe2';
    npe2 = GetFromProcpar(dir,textstring);
    
    for a=1:npe2
        for b=1:npe1
            ptr = b + (a-1)*npe1;
            pevalues(ptr) = a + (b-1)*npe2;
        end
    end
else
    for a=1:res
        pevalues(a) = a;
    end
end

if (encodetable==0)
    stripheader(fp1,1);
    
    for a=1:res
        
        for d=1:rcvrs
            
            stripheader(fp1,2);
            
            for b=1:B0s
                for c=1:slices
                    temp(1:totreads) = fread(fp1,totreads,'int');
                    data(1:totreads,a,d,c,b) = temp(1:totreads);
                end
            end
        end
    end
end

if (encodetable==1)
    stripheader(fp1,1);
    for d=1:rcvrs
        stripheader(fp1,2);
        for a1=1:npe2
            
            %for d=1:rcvrs
            
            
            
            for b=1:B0s
                for a2 = 1:npe1
                    ptr = a2 + (a1-1)*npe1;
                    peptr = pevalues(ptr);
                    for c=1:slices
                        temp(1:totreads) = fread(fp1,totreads,'int');
                        data(1:totreads,peptr,d,c,b) = temp(1:totreads);
                    end
                end
            end
        end
    end
end





size(data)
%max(max(max(max(max(data)))))
fclose(fp1);

% write pc file for convenience
eh = findobj(gcf,'Tag','ImageFileType1');
set(eh,'Value',2);

eh = findobj(gcf,'Tag','ExtIn10');
%sn0 = get(eh,'String');
sn0=1;
set(eh,'String',sn0);
switch(imagetype)
    case 1
        fileout = MakeName1;
    case 2
        fileout = MakeName1Scout;
end
fp2 = fopen(fileout,'w');
fwrite(fp2,data,'float');
fclose(fp2);


