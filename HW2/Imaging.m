%clear;clc;
filename = 'VID_20191024_000508.avi'; % = 1280 * 720
v = VideoReader(filename);
numFrames = v.NumberOfFrames; % = 1049
frameRate = v.FrameRate; % = 30
duration = v.Duration; % = 34.9870s
frame = read(v, 1);

%%
% Q2.2, Figure 4
i = 150;
%i = 600;
%i = 960;
frame = read(v, i);
frame = insertText(frame,[30,30],strcat('Frame',32,num2str(i)),'Font','Arial','TextColor','black','FontSize',40,'BoxOpacity',0);
imshow(frame);
%imwrite(frame, strcat('testimg-',num2str(i),'.jpg'), 'jpg');

%%
% Q2.3, Figure 5
imgray = rgb2gray(frame);
imshow(imgray);
%imwrite(imgray, 'imgray.jpg', 'jpg');

%%
% Q2.4.1
% For plants; for bag
imgedge = read(v, 1); % lefttop: [x, y] = [618, 358]; [480, 530]
%imgedge = read(v, 239); % righttop: [x, y] = [392, 354]; [580, 180]
%imgedge = read(v, 443); % right: [x, y] = [408, 290]; [606, 114]
%imgedge = read(v, 645); % left: [x, y] = [645, 305]; [807, 128]
%imgedge = read(v, 819); % leftbottom: [x, y] = [645, 220]; [802, 46]
%imgedge = read(v, 1043); % rightbottom: [x, y] = [362, 210]; [567, 32]

set(gcf, 'Position', [0,0,1280, 720]);
imshow(imgedge,'border','tight');

% For plants
%rectangle('Position', [362, 210, 525, 390], 'LineWidth', 3, 'EdgeColor', [136/255 54/255 248/255]); % window: [w, h] = [525, 385]
%rectangle('Position', [618, 358, 240, 240], 'LineWidth', 3, 'EdgeColor', 'r'); % template: [w, h] = [240, 240]

% For bag
rectangle('Position', [180, 400, 520, 315], 'LineWidth', 3, 'EdgeColor', [136/255 54/255 248/255]); % window: [w, h] = [525, 385]
rectangle('Position', [480, 530, 180, 180], 'LineWidth', 3, 'EdgeColor', 'r'); % template: [w, h] = [160, 160]

axis normal;
%saveas(gca, 'pset_template.jpg', 'jpg');
%saveas(gca, 'pset_window.jpg', 'jpg');

%%
% Q2.4.2
frame = read(v, 1);
template = frame(530:(530+180),480:(480+180),:);
window = frame(400:(400+315), 180:(180+520), :);
corr = normxcorr2(rgb2gray(template), rgb2gray(window));
imagesc(corr);
colormap('gray');
colorbar;
xlabel('Pixel location in X Direction');
ylabel('Pixel location in Y Direction');
%saveas(gca, 'pset_normcorr.jpg', 'jpg');

%%
% Q2.4.3
x = [];
y = [];
for i = 1:numFrames
   frame = read(v, i);
   window = frame(400:(400+315), 180:(180+520), :);
   corr = normxcorr2(rgb2gray(template), rgb2gray(window));
   [corrmax, corrI] = max(corr);
   [~, corry] = max(corrmax);
   corrx = corrI(corry);
   x = [x corrx];
   y = [y corry];
end

path = plot(x,y);
xlabel('X Pixel Shift');
ylabel('Y Pixel Shift');
%saveas(gca, 'pset_path.jpg', 'jpg');

%%
% Q2.5
%i = 1;
%frame = read(v, i);
%object = frame((y(i)-25):(y(i)+215),(x(i)+120):(x(i)+360),:);

output = zeros(720, 1280, 3, 'uint32');
numout = zeros(720, 1280, 'uint32');
for i = 1:numFrames
    trans = uint32(imtranslate(read(v, i), [-y(i)+y(1), -x(i)+x(1)]));
    output = output + trans;
    for j = 1:720
        for k = 1:1280
            if trans(j,k,1) ~= 0 || trans(j,k,2) ~= 0 || trans(j,k,3) ~= 0
                numout(j,k) = numout(j,k) + 1;
            end
        end
    end
end

output = uint8(output./numout);
imshow(output);
%imwrite(output, 'pset_output.jpg', 'jpg');

%%
% Q3.1
deltax=[-0.5, 0, 0, 1, 1, 1.5];
deltay=[0, 0, 1, 1, 0, 0];
plot(deltax, deltay, 'color', 'b', 'linewidth', 2);
xlim([-0.3, 1.3]);
ylim([-0.5,1.5]);
xticks([0, 1]);
xticklabels({0, '¡÷_2'});
yticks([0, 1]);
yticklabels({0, '1/¡÷_2'});
title('FWHM of the blur kernel ($W$)', 'Interpreter', 'latex');
xlabel('$x$', 'Interpreter', 'latex', 'fontsize', 12);
ylabel('$f(x)$', 'Interpreter', 'latex', 'fontsize', 12);
set(gca, 'xgrid', 'on', 'linewidth', 1, 'gridalpha', 0.5);
set(gca, 'ygrid', 'on');
%saveas(gca, 'FWHM_func.jpg', 'jpg');
%axes('position', [0,0,1,1]);

%%
% Q3.3
deltax = 10:100;
deltay = (deltax-10)./(10.*deltax);
plot(deltax-10, deltay, 'color', 'b', 'linewidth', 2);
set(gca, 'xtick', [], 'ytick', []);
axis normal;
xlim([0, 100]);
ylim([0, 0.1]);
xlabel('$|Z_2-Z_1|$', 'Interpreter', 'latex', 'fontsize', 12);
ylabel('$W$', 'Interpreter', 'latex', 'fontsize', 12);
title('Relationship between $W$ and $|Z_2-Z_1|$', 'Interpreter', 'latex');
text(35, 0.065, 'slope = $$\frac{f\Delta}{Z_1 Z_2}$$', 'Interpreter', 'latex', 'fontsize', 12);
text(-3, -0.0035, '\it0', 'Interpreter', 'latex', 'fontsize', 14);
%saveas(gca, 'pset_3_3.jpg', 'jpg');

%%
% Q3.4
deltax = 0:1;
deltay = 0:1;
plot(deltax, deltay, 'color', 'b', 'linewidth', 2);
set(gca, 'xtick', [], 'ytick', []);
axis normal;
xlim([0, 1.1]);
ylim([0, 1.1]);
xlabel('$f$', 'Interpreter', 'latex', 'fontsize', 12);
ylabel('$W$', 'Interpreter', 'latex', 'fontsize', 12);
title('Relationship between $W$ and $f$', 'Interpreter', 'latex');
text(0.28, 0.75, 'slope = $$\frac{|Z_2-Z_1|\Delta}{Z_1 Z_2}$$', 'Interpreter', 'latex', 'fontsize', 12);
text(-0.035, -0.035, '\it0', 'Interpreter', 'latex', 'fontsize', 14);
%saveas(gca, 'pset_3_4.jpg', 'jpg');

%%











