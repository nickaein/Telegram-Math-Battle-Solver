function img = captureScreen(x, y, w, h)
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();

%# Set the capture area as the size for the screen
rectangle = java.awt.Rectangle(t.getScreenSize());
rectangle.x = x;
rectangle.y = y;
rectangle.width = w;
rectangle.height = h;

%# Get the capture
img = robo.createScreenCapture(rectangle);
img = java_img2mat(img);
end