%gradientDescentDemo: Interactive demo of Gradient descent paths on "peaks" surface
%
%	Usage:
%		gradientDescentDemo
%
%	Description:
%		gradientDescentDemo gives interactive demo of gradient descent paths on "peaks" surface
%
%	Example:
%		gradientDescentDemo

%	Category: Demos
%	Roger Jang, 19961016, 20080801, 20160925

%figure('name', 'Gradient Descent', 'NumberTitle', 'off');
subplot(1,2,1);
x=-3:.1:3;
y=-3:.1:3;
[xx,yy]=meshgrid(x,y);
zz=peaks(xx,yy);
surf(xx, yy, zz);
axis([min(x) max(x) min(y) max(y) min(zz(:)) max(zz(:))]);
colormap((jet+white)/2);
ball3dH=line(nan, nan, nan, 'marker', '.', 'markersize', 10, 'color', 'k');
set(gca, 'box', 'on');

%figure('name', 'Gradient Descent', 'NumberTitle', 'off');
subplot(1,2,2);
h=pcolor(xx,yy,zz);
hold on
colormap((jet+white)/2);
[junk, contourH] = contour(xx, yy, zz, 20, 'k-');
shading interp;
%[px,py]=gradient(zz,.2,.2);
%quiver(x,y,-px,-py,2,'k');
hold off;
axis([min(x) max(x) min(y) max(y)]); axis square;
ball2dH=line(nan, nan, 'marker', '.', 'markersize', 10, 'color', 'k');
title('Click to see gradient-descent paths');

AxisH = gca; FigH = gcf;
obj_fcn = 'peaksFunc';
eta = 0.05;

% The following is for animation
% action when button is first pushed down
% This action draws GD path on 3D surface too
action1 = ['subplot(1,2,2); segment2dH=line(nan, nan, ''color'', ''r'');', ...
	'subplot(1,2,1); segment3dH=line(nan, nan, nan, ''color'', ''r'');', ...
	'curr_info=get(AxisH, ''currentPoint'');', ...
	'x=curr_info(1,1);y=curr_info(1,2);z=feval(obj_fcn,x,y);', ...
	'set(ball2dH,''xdata'',x,''ydata'',y);', ...
	'set(ball3dH,''xdata'',x,''ydata'',y,''zdata'',z);', ...
	'for i=1:200,', ...
	'grad=feval(obj_fcn,x(end),y(end),1);', ...
	'tmp=-grad/norm(grad);', ...
	'new_x=x(end)+eta*tmp(1);', ...
	'new_y=y(end)+eta*tmp(2);', ...
	'new_z=feval(obj_fcn,new_x,new_y);', ...
	'x=[x; new_x]; y=[y; new_y]; z=[z; new_z];'...
	'set(segment2dH,''xdata'',x,''ydata'',y);', ...
	'set(segment3dH,''xdata'',x,''ydata'',y,''zdata'',z);', ...
	'end'];

% actions after the mouse is pushed down
action2 = action1;
% action when button is released
action3 = action1;

% temporary storage for the recall in the down_action
set(AxisH,'UserData',action2);

% set action when the mouse is pushed down
down_action=['set(FigH,''WindowButtonMotionFcn'',get(AxisH,''UserData''));', action1];
set(FigH,'WindowButtonDownFcn',down_action);

% set action when the mouse is released
up_action=['set(FigH,''WindowButtonMotionFcn'','' '');', action3];
set(FigH,'WindowButtonUpFcn',up_action);
