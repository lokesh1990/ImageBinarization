function [ outImg ] = applyShrinkSwellFilter( ipImg )
% applyShrinkSwellFilter The filter applying shrink swell filter to the
% image and then returns the output binary image

% morphological operations
ipImg = bwmorph(ipImg,'spur');
ipImg = bwmorph(ipImg,'majority');
ipImg = bwmorph(ipImg,'bridge');
ipImg = bwmorph(ipImg,'diag');
ipImg = bwmorph(ipImg,'open');
ipImg = bwmorph(ipImg,'spur');
ipImg = bwmorph(ipImg,'clean');

% correct the smaller areas 
ipImg = padarray(ipImg, 1,'symmetric','both');
[m n] = size(ipImg);
r1 = 3; %CalcStrokeWidth(ipImg) - 1;
r2 = r1;
mr = floor(m/r1);
nr = floor(n/r2);
num1 = 0;
num2 = 0;
outImg = ipImg;

for i = 0 : mr-1
    for j = 0 : nr-1
        num1 = 0;
        num2 = 0;
        for k = 1 : r1
            for l = 1 : r2
                if(ipImg((i*r1)+k, (j*r2)+l) == 1)
                    if((k < r1) && (l < r2))
                        num2 = num2 + 1;
                    end
                    num1 = num1 + 1;
                end
            end
        end
        if(num1 == num2)
            outImg((i*r1)+1 : (i*r1)+r1-1, (j*r2)+1 : (j*r2)+r2-1) = 0;
        elseif (num1 == (num2+2*(r1+r2-2)))
            outImg((i*r1)+1 : (i*r1)+r1-1, (j*r2)+1 : (j*r2)+r2-1) = 1;
        end
    end
end

end

