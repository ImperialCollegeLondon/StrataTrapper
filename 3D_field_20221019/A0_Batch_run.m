
clc
clear
close all 

fid = fopen('A_input.txt','r');
eformat = '[+-]?\d+\.?\d*([eE][+-]?\d+)?';
vformat = '\d+\.?\d*';
tline=0;

while tline~=-1
    tline = fgetl(fid); 
    while isempty(tline); tline = fgetl(fid); end
    if tline==-1; break; end
    %Correlation lengths in grid cells. 
    %corr_lengths_iso = [0 10 2; 1 1 1; 2 2 2]; 
    if tline(1:5)=="*corr"
        B = regexp(tline,vformat,'match');
        corr_lengths_iso = reshape(cellfun(@str2num,B),3,[])';
        [size_iso,~]  = size(corr_lengths_iso);
    end
    if tline(1:6)=="*Nreal"
        B = regexp(tline,vformat,'match');
        N_real = cellfun(@str2num,B);
    end
end
fclose(fid);
fclose('all');


%Run fine scale simulations. 

for IT = 1:1 %12
    for i = 1:size_iso
        for j = 1:N_real
         corr_lengthx = corr_lengths_iso(i,1); 
         corr_lengthy = corr_lengths_iso(i,2);
         corr_lengthz = corr_lengths_iso(i,3); 
         realization = j;
         A0_Main_code_upscaling(corr_lengthx,corr_lengthy,corr_lengthz,realization, IT); %, N_Qg, Qg_tot, Reservior_bottom, Reservior_top, Lx, Ly, por_std, pore_vol_injected, dt_nd);
        end
    end
end



