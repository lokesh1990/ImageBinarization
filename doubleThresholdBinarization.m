function [ outImg ] = doubleThresholdBinarization( ipImg, Iorg)
%function to calculate the double threshold values which seperate the image
%to text regions, near text regions and background regions

[t1, t2, hb, hbw, hw] = calcDBLThreshold(ipImg);
thrBnImg = ipImg;
hbw = 127;
hbw = uint8(hbw);

for i=1:numel(thrBnImg)
    if(thrBnImg(i) <= t1)
        thrBnImg(i) = 0;
    elseif(thrBnImg(i) > t1 && thrBnImg(i) < t2)
        thrBnImg(i) = hbw;
    else
        thrBnImg(i) = 255;
    end
end

% define interval 7 (2a+1)
w = 3;
% calculate num, Imean, Istd
ipBinPadArr = padarray(thrBnImg, w,'symmetric','both');
ipPad = padarray(Iorg, w,'symmetric','both');

[m, n] = size(ipBinPadArr);

for i=w+1:m-w
    for j=w+1:n-w
        if(ipBinPadArr(i,j) == hbw)
            num = 0;
            Imean = 0.0;
            Istd = 0.0;
            for k=i-w:i+w
                for l=j-w:j+w
                    Imean = Imean + ipPad(k,l)*ipBinPadArr(k,l); 
                    if(ipBinPadArr(k,l) == hbw)
                        num = num+1;
                    end
                end                
            end
            if(num == 0)
                continue;
            end
            Imean = Imean/num;
            for k=i-w:i+w
                for l=j-w:j+w
                    Istd = Istd + ((ipPad(k,l)*ipBinPadArr(k,l))-Imean)^2;
                end
            end
            Istd = double(Istd);
            Istd = sqrt(Istd/num);
            if(ipPad(i,j) < (Istd+Imean) && ipPad(i,j) < t2)
                ipBinPadArr(i,j) = hw;
            else
                ipBinPadArr(i,j) = hb;
            end
        end
    end
end
ipBinPadArr = ipBinPadArr(w+1:m-w, w+1:n-w);
outImg = im2bw(ipBinPadArr, (hbw/255));

end

