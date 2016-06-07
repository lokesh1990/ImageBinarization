function [ outImg ] = graphBuild( ipImg, strokeImg )
% build a graph of blocks of the image as mentioned and remove the blocks
% included in the generated graphs to remove block noise

w = CalcStrokeWidth(strokeImg) + 1;
w = uint8(2*w+1);
[m, n] = size(ipImg);
rm = floor(m/w);
rn = floor(n/w);
markNodes = zeros(rm, rn);
outImg = ipImg;
set(0,'RecursionLimit',1200);

for i = 0:rm-1
    for j = 0:rn-1
        if(sum(sum(ipImg((i*w)+1 : (i*w)+w, (j*w)+1 : (j*w)+w))) == 0 && markNodes(i+1, j+1) == 0)
            markNodes(i+1, j+1) = 1;
            for k = 1:w
                for l = 1:w
                    outImg(((i+1)*w)+k, ((j+1)*w)+l) = 0; 
                end
            end
            [outImg, markNodes] = markNeighbour(outImg, markNodes, i+1, j+1, w);
        end
    end
end

end

function [outImg, markNodes] = markNeighbour (ipImg, nodesLst, iEle, jEle, w)
% recursive function to mark and remove the neighbour nodes belonging to
% the graph

[rm, rn] = size(nodesLst);
markNodes = nodesLst;
%n1Arr,n2Arr
%edgeExist = 0;
outImg = ipImg;

if(iEle > 1)
    if(markNodes(iEle-1, jEle) == 0)
        wCnt = sum(sum(outImg(((iEle-1)*w)+1 : ((iEle-1)*w)+w, (jEle*w)+1 : (jEle*w)+w)));
        bCnt = (w * w) - wCnt;
        n1Arr = outImg(((iEle-1)*w)+w, (jEle*w)+1 : (jEle*w)+w);
        n2Arr = outImg((iEle*w)+1, (jEle*w)+1 : (jEle*w)+w);
        edgeExist = 0;
        for i = 1:numel(n1Arr)
            if(n1Arr(i) == 0 && n2Arr(i) == 0)
               edgeExist = 1;
               break;
            end
        end

        if(bCnt > 2*wCnt && edgeExist == 1)
            markNodes(iEle-1, jEle) = 1;
            for i = 1:w
                for j = 1:w
                    outImg(((iEle-1)*w)+i, (jEle*w)+j) = 0; 
                end
            end
            [outImg, markNodes] = markNeighbour(outImg, markNodes, iEle-1, jEle, w);
        end
    end
end

if(iEle < rm-1)
    if(markNodes(iEle+1, jEle) == 0)
        wCnt = sum(sum(outImg(((iEle+1)*w)+1 : ((iEle+1)*w)+w, (jEle*w)+1 : (jEle*w)+w)));
        bCnt = (w * w) - wCnt;
        n1Arr = outImg((iEle*w)+w, (jEle*w)+1 : (jEle*w)+w);
        n2Arr = outImg(((iEle+1)*w)+1, (jEle*w)+1 : (jEle*w)+w);
        edgeExist = 0;
        for i = 1:numel(n1Arr)
            if(n1Arr(i) == 0 && n2Arr(i) == 0)
               edgeExist = 1;
               break;
            end
        end

        if(bCnt > 2*wCnt && edgeExist == 1)
            markNodes(iEle+1, jEle) = 1;
            for i = 1:w
                for j = 1:w
                    outImg(((iEle+1)*w)+i, (jEle*w)+j) = 0; 
                end
            end
            [outImg, markNodes] = markNeighbour(outImg, markNodes, iEle+1, jEle, w);
        end
    end
end

if(jEle > 1)
    if(markNodes(iEle, jEle-1) == 0)
        wCnt = sum(sum(outImg((iEle*w)+1 : (iEle*w)+w, ((jEle-1)*w)+1 : ((jEle-1)*w)+w)));
        bCnt = (w * w) - wCnt;
        n1Arr = outImg((iEle*w)+1 : (iEle*w)+w, ((jEle-1)*w)+w);
        n2Arr = outImg((iEle*w)+1 : (iEle*w)+w, (jEle*w)+1);
        edgeExist = 0;
        for i = 1:numel(n1Arr)
            if(n1Arr(i) == 0 && n2Arr(i) == 0)
               edgeExist = 1;
               break;
            end
        end

        if(bCnt > 2*wCnt && edgeExist == 1)
            markNodes(iEle, jEle-1) = 1;
            for i = 1:w
                for j = 1:w
                    outImg((iEle*w)+i, ((jEle-1)*w)+j) = 0; 
                end
            end
            [outImg, markNodes] = markNeighbour(outImg, markNodes, iEle, jEle-1, w);
        end
    end
end

if(jEle < rn-1)
    if(markNodes(iEle, jEle+1) == 0)
        wCnt = sum(sum(outImg((iEle*w)+1 : (iEle*w)+w, ((jEle+1)*w)+1 : ((jEle+1)*w)+w)));
        bCnt = (w * w) - wCnt;
        n1Arr = outImg((iEle*w)+1 : (iEle*w)+w, ((jEle+1)*w)+1);
        n2Arr = outImg((iEle*w)+1 : (iEle*w)+w, (jEle*w)+w);
        edgeExist = 0;
        for i = 1:numel(n1Arr)
            if(n1Arr(i) == 0 && n2Arr(i) == 0)
               edgeExist = 1;
               break;
            end
        end

        if(bCnt > 2*wCnt && edgeExist == 1)
            markNodes(iEle, jEle+1) = 1;
            for i = 1:w
                for j = 1:w
                    outImg((iEle*w)+i, ((jEle+1)*w)+j) = 0; 
                end
            end
            [outImg, markNodes] = markNeighbour(outImg, markNodes, iEle, jEle+1, w);
        end
    end
end

end