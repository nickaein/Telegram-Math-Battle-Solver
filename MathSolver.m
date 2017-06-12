areaLeft = 500;
areaTop = 150;
areaWidth = 300;
areaHeight = 200;

desiredScore = 100;

symbolsChar = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ...
    'Plus', 'Minus', 'Multiply', 'Divide', 'Equal'};

symbolImages = {};
for i=1:length(symbolsChar)
    symbol = imread(sprintf('Symbols\\%s.png',symbolsChar{i}));
    symbol = rgb2gray(symbol);
    symbol = mat2gray(symbol);
    symbol = symbol - mean(symbol(:));
    symbol = symbol - var(symbol(:));
    symbolImages{i} = symbol;
end

robo = java.awt.Robot;
while(desiredScore > 0)
    pause(0.1);
    img = captureScreen(areaLeft,areaTop,areaWidth,areaHeight);
%     img = imread('Samples\Sample5.png');
%     img = img(areaTop:areaTop+areaHeight,areaLeft:areaLeft+areaWidth,:);
    img = mat2gray(rgb2gray(img));
    result = evaluateImageEquation(img, symbolImages, symbolsChar);
    if(result==2)
        desiredScore = desiredScore - 1;
        robo.keyPress(java.awt.event.KeyEvent.VK_LEFT);
    elseif(result==1)
        desiredScore = desiredScore - 1;
        robo.keyPress(java.awt.event.KeyEvent.VK_RIGHT);
    else
%         fprintf('Cannot find equation on screen.\n');
    end
end
