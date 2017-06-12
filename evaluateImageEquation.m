function evalResult = evaluateImageEquation(img, symbolImages, symbolsChar)
evalResult = 0;
img = img - mean(img(:));
img = img / var(img(:));
foundSymbolsX = [];
foundSymbolsY = [];
foundSymbolsId = [];

recognitionThreshold = 0.9;

for i=1:length(symbolImages)
    symbol = symbolImages{i};
    res = normxcorr2(symbol,img);
    threshold = Inf;
    while(threshold >= recognitionThreshold)
        [maxyValues, maxyValueInds] = max(res);
        [threshold, y] = max(maxyValues);
        x = maxyValueInds(y);

        if(threshold > recognitionThreshold)
            symbol = symbolImages{i};
            img(x-size(symbol,1)+4:x-4, y-size(symbol,2)+4:y-4) = 0;
            res(x-floor(size(symbol,1)/2)+2:x+floor(size(symbol,1)/2)-2, ...
                y-floor(size(symbol,2)/2)+2:y+floor(size(symbol,2)/2)-2) = 0;
            foundSymbolsX = [foundSymbolsX x];
            foundSymbolsY = [foundSymbolsY y];
            foundSymbolsId = [foundSymbolsId i];
        end
    end
end    

if(length(foundSymbolsX) < 5)
    return;
end

[foundSymbolsX,Ind] = sort(foundSymbolsX);
foundSymbolsY = foundSymbolsY(Ind);
foundSymbolsId = foundSymbolsId(Ind);

[~,RowChangeInd] = max(diff(foundSymbolsX));

foundSymbolsYTopRow = foundSymbolsY(1:RowChangeInd);
foundSymbolsYBottomRow = foundSymbolsY(RowChangeInd+1:end);

foundSymbolsIdTopRow = foundSymbolsId(1:RowChangeInd);
foundSymbolsIdBottomRow = foundSymbolsId(RowChangeInd+1:end);

[~,Ind] = sort(foundSymbolsYTopRow);
foundSymbolsIdTopRow = foundSymbolsIdTopRow(Ind);

[~,Ind] = sort(foundSymbolsYBottomRow);
foundSymbolsIdBottomRow = foundSymbolsIdBottomRow(Ind);

str = [symbolsChar(foundSymbolsIdTopRow) symbolsChar(foundSymbolsIdBottomRow)];
str = cell2mat(str);
str = strrep(str,'Equal','==');
str = strrep(str,'Plus','+');
str = strrep(str,'Minus','-');
str = strrep(str,'Multiply','*');
str = strrep(str,'Divide','/');

isCorrect = eval(str);
if(isCorrect)
    evalResult = 2;
else
    evalResult = 1;
end
fprintf('%s: %d\n', str, isCorrect);
end
