% Q2.1 Separation of global and direct component
clear;clc;
filelist = pwd;
file = dir(filelist);
file_index = [];
for i = 1:length(file)
    if length(file(i).name) > 5 && strcmp(file(i).name((end-3):end), '.png') && strcmp(file(i).name(1), 's')
        file_index(end + 1) = i;
    end
end
img_file = file(file_index);

%%
im_max = imread('black.png');
[W, L, ~] = size(im_max);
im_min = ones(W, L, 3, 'uint8') * 255;

im = [];
for i = 1 : length(img_file)
    im(:,:,:,end + 1) = imread(img_file(i).name);
end
im(:,:,:,1) = [];

%%
% brightness = r+g+b
for i = 1 : W
    for j = 1 : L
        [~, index_max] = max(int16(im(i,j,1,:)) + int16(im(i,j,2,:)) + int16(im(i,j,3,:)));
        [~, index_min] = min(int16(im(i,j,1,:)) + int16(im(i,j,2,:)) + int16(im(i,j,3,:)));
        
        im_max(i,j,:) = uint8(im(i,j,:,index_max));
        im_min(i,j,:) = uint8(im(i,j,:,index_min));
    end
end

%%
% brightness = max{r, g, b}
for i = 1 : W
    for j = 1 : L
        for k = 1 : length(img_file)
            bright(k) = max(max(im(i,j,1,k), im(i,j,2,k)), im(i,j,3,k));
        end
        
        [~, index_max] = max(bright);
        [~, index_min] = min(bright);

        im_max(i,j,:) = uint8(im(i,j,:,index_max));
        im_min(i,j,:) = uint8(im(i,j,:,index_min));
    end
end

%%
% b from each r, g, b
b = double(imread('black.png'))./double(imread('white.png'));

%%
% b from brightness only
black = imread('black.png');
white = imread('white.png');
b = zeros(W, L, 'double');
for i = 1 : W
    for j = 1 : L
        bright_black = max(black(i,j,:));
        bright_white = max(white(i,j,:));
        b(i, j) = double(bright_black)/double(bright_white);
        if b(i, j) > 1
            b(i, j) = 1;
        end
    end
end

%%
im_d = uint8((double(im_max) - double(im_min))./(1 - b));
im_g = uint8((-b .* double(im_max) + double(im_min)) ./(1 - b .* b) * 2);
figure;imshow(im_d);
figure;imshow(im_g);

%imwrite(im_d, 'quiz3a_scene3_direct.png', 'png');
%imwrite(im_g, 'quiz3a_scene3_global.png', 'png');

%%




%%
% Q2.2 Image-based relighting
%clear;clc;
testset = 'test1';
file1 = strcat(testset, '-Lamp1.jpg');
file2 = strcat(testset, '-Lamp2.jpg');
im1 = imread(file1);
im2 = imread(file2);
[W, L, ~] = size(im1);

%%
% Q2.2.3, Figure 7 synthesis
black = imread(strcat(testset, '-black.jpg'));
syn = uint8(int16(im1) + int16(im2) - int16(black));
%syn = im1 + im2;
imshow(syn);

%imwrite(syn, 'quiz3b_synth.jpg', 'jpg');

%%
% Q2.2.3, Figure 7 difference
file_scene = strcat(testset, '-Lamps.jpg');
scene = imread(file_scene);

diff = int16(im1) + int16(im2) - int16(scene) - int16(black);
%diff = abs(diff);
diff = double(diff);
diff_rescale = diff./max(max(diff))*255;
diff_rescale = uint8(diff_rescale);
imshow(diff_rescale);

%imwrite(diff_rescale, 'quiz3b_difference.jpg','jpg');

%%
% Q2.2.3, Figure 7 difference (initial version)
file_scene = strcat(testset, '-Lamps.jpg');
scene = imread(file_scene);

%diff = syn - scene;
diff = int16(syn) - int16(scene);
%diff = abs(diff);
diff = double(diff);
diff_rescale = diff./max(max(diff))*255;
diff_rescale = uint8(diff_rescale);
imshow(diff_rescale);

%imwrite(diff_rescale, 'quiz3b_difference.jpg','jpg');

%%
% Q2.2.4, Figure 8
im_relight(:,:,1) = uint8(im1(:,:,1));
im_relight(:,:,2) = uint8(im2(:,:,2));
im_relight(:,:,3) = uint8((int16(im1(:,:,3)) + int16(im2(:,:,3))));
imshow(im_relight);

%imwrite(im_relight, 'quiz3b_synth2.jpg');

%%




