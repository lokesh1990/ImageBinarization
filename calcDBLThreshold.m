function [ Th1, Th2, hb, hbw, hw ] = calcDBLThreshold( ipImg )
% This function calculates 2 threshold values of the input gray scale image
% using the Shannon based entropy method
% It returns 2 output threshold values

max = 0.0;
Th1 = 0;
Th2 = 0;

img_hst = imhist(ipImg);
pb = 0.0;
pbw = 0.0;
pw = 0.0;

nTot = numel(ipImg);
tmp = 0.0 ;

for i = 1 : numel(img_hst)
    for j = 1 : numel(img_hst)
        pb = 0.0;
        pbw = 0.0;
        pw = 0.0;
        
        for k = 1 : i
            pb = pb + (img_hst(k)/ nTot);
        end
        for k = i + 1 : j
            pbw = pbw + (img_hst(k)/ nTot);
        end
        for k = j + 1 : numel(img_hst)
            pw = pw + (img_hst(k)/ nTot);
        end
        
        if(pb == 0 | pw == 0 | pbw == 0)
            continue;
        end

        %hs = 0.0;
        hbTmp = 0.0;
        hbwTmp = 0.0;
        hwTmp = 0.0;
        for k = 1 : i
            tmp = (img_hst(k) / nTot) / pb;
            if(tmp == 0)
                continue;
            end
            hbTmp = hbTmp - tmp * log(tmp);
        end
        for k = i+1 : j
            tmp = (img_hst(k) / nTot) / pbw;
            if(tmp == 0)
                continue;
            end
            hbwTmp = hbwTmp - tmp * log(tmp);
        end
        for k = j+1 : numel(img_hst)
            tmp = (img_hst(k) / nTot) / pw;
            if(tmp == 0)
                continue;
            end
            hwTmp = hwTmp - tmp * log(tmp);
        end
        hs = hbTmp + hbwTmp + hwTmp;
        
        if hs > max
            max = hs;
            Th1 = i - 1;
            Th2 = j - 1;
            hb = hbTmp;
            hbw = hbwTmp;
            hw = hwTmp;
        end
    end
end

%disp('Threshold values are ');
%disp([Th1, Th2]);

end

