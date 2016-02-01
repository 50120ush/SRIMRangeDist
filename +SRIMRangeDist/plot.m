function plot(x,yi,legendStr)
%% Plot
%  This function does all the plotting when the PLOT button is pressed.
%
% Tested on:
%  - MATLAB R2015b
%
% Copyright: Herianto Lim
% http://heriantolim.com/
% First created: 31/01/2016
% Last modified: 01/02/2015

%% Parameters
CONF_INT=[.025,.975];

PLOT_LINE_COLOR='k';
PLOT_LINE_STYLE={'-','-'};
PLOT_LINE_WIDTH=[.75,1];

CURSOR_COLOR='r';
CURSOR_LINE_STYLE='--';
CURSOR_LINE_WIDTH=1;
CURSOR_MARKER_STYLE='+';
CURSOR_MARKER_SIZE=12;

RECTANGLE_FONT_SIZE=14;
RECTANGLE_COLOR='r';
RECTANGLE_LINE_STYLE='--';
RECTANGLE_LINE_WIDTH=1;

LEGEND_LOCATION='NorthEast';
LEGEND_FONT_SIZE=12;
LEGEND_LINE_WIDTH=1;

%% Data Processing
[~,M]=size(yi);
y=sum(yi,2);% total distribution
s=cumsum(y);% cumulative sum of total distribution
s=s/s(end);
x1=find(s>=CONF_INT(1),1,'first');% lower bound of the confidence interval
xm=find(s>=.5,1,'first');% mean
x2=find(s<=CONF_INT(2),1,'last');% upper bound of the confidence interval
y1=min(y(x1:x2));
y2=max(y);
ym=mean(y(x1:x2));
x1=x(x1);
xm=x(xm);
x2=x(x2);
yLim=[0,1.1*y2];

%% Plots
hold(gca,'all');
set(gca,'YLim',yLim);
for m=1:M
	plot(x,yi(:,m), ...
		'LineStyle',PLOT_LINE_STYLE{1}, ...
		'LineWidth',PLOT_LINE_WIDTH(1));
end
plot(x,y, ...
	'Color',PLOT_LINE_COLOR, ...
	'LineStyle',PLOT_LINE_STYLE{2}, ...
	'LineWidth',PLOT_LINE_WIDTH(2));

%% Annotation
XLim=get(gca,'XLim');
plot([XLim(1),x1],[ym,ym], ...
	'Color',CURSOR_COLOR, ...
	'LineStyle',CURSOR_LINE_STYLE, ...
	'LineWidth',CURSOR_LINE_WIDTH);
plot([x2,XLim(2)],[ym,ym], ...
	'Color',CURSOR_COLOR, ...
	'LineStyle',CURSOR_LINE_STYLE, ...
	'LineWidth',CURSOR_LINE_WIDTH);
plot([xm,xm],[yLim(1),y1], ...
	'Color',CURSOR_COLOR, ...
	'LineStyle',CURSOR_LINE_STYLE, ...
	'LineWidth',CURSOR_LINE_WIDTH);
plot([xm,xm],[y2,yLim(2)], ...
	'Color',CURSOR_COLOR, ...
	'LineStyle',CURSOR_LINE_STYLE, ...
	'LineWidth',CURSOR_LINE_WIDTH);
rectangle('Position',[x1,y1,x2-x1,y2-y1], ...
	'EdgeColor',RECTANGLE_COLOR, ...
	'FaceColor','none', ...
	'LineStyle',RECTANGLE_LINE_STYLE, ...
	'LineWidth',RECTANGLE_LINE_WIDTH);
plot(xm,ym, ...
	'MarkerEdgeColor',CURSOR_COLOR, ...
	'MarkerFaceColor',CURSOR_COLOR, ...
	'Marker',CURSOR_MARKER_STYLE, ...
	'MarkerSize',CURSOR_MARKER_SIZE);
text(x2,y2,'95% CI ', ...
	'Color',RECTANGLE_COLOR, ...
	'FontSize',RECTANGLE_FONT_SIZE, ...
	'HorizontalAlignment','right', ...
	'VerticalAlignment','top');
TextHandle=text(x2,ym,sprintf('  x-mean = %d',round(xm)), ...
	'Color',RECTANGLE_COLOR, ...
	'FontSize',RECTANGLE_FONT_SIZE, ...
	'HorizontalAlignment','left', ...
	'VerticalAlignment','top');
p=get(TextHandle,'Extent');
text(x2,ym-p(4),sprintf('  x-range = %g ',x2-x1), ...
	'Color',RECTANGLE_COLOR, ...
	'FontSize',RECTANGLE_FONT_SIZE, ...
	'HorizontalAlignment','left', ...
	'VerticalAlignment','top');
text(x2,ym-2*p(4),sprintf('  y-mean = %g',ym), ...
	'Color',RECTANGLE_COLOR, ...
	'FontSize',RECTANGLE_FONT_SIZE, ...
	'HorizontalAlignment','left', ...
	'VerticalAlignment','top');
text(x2,ym-3*p(4),sprintf('  y-range = %g ',y2-y1), ...
	'Color',RECTANGLE_COLOR, ...
	'FontSize',RECTANGLE_FONT_SIZE, ...
	'HorizontalAlignment','left', ...
	'VerticalAlignment','top');

%% Legend
legend(gca, ...
	'Location',LEGEND_LOCATION, ...
	'String',[legendStr;{'total'}], ...
	'FontSize',LEGEND_FONT_SIZE, ...
	'LineWidth',LEGEND_LINE_WIDTH, ...
	'Tag','Legend');

end