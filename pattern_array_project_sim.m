close all
clear all
path_pattern = 'D:\projects\Hollywood\940nm_DOE_10cm.jpg';
im_in = imread(path_pattern);
imshow(im_in);

center = [4476 6456];
x_rad = 3222;
y_rad = 3030;
pad_sz = 700;
%%
crop_pat = im_in(center(1)-y_rad:center(1)+y_rad, center(2)-x_rad:center(2)+x_rad, 1);
figure
imshow(crop_pat)



pat_center = size(crop_pat)/2+[0.5 0.5];
pat_center_x = pat_center(2);
pat_center_y = pat_center(1);


crop_pat = double(crop_pat);
crop_pat_padding = padarray(crop_pat,[pad_sz pad_sz],0,'both');

figure
imagesc(crop_pat_padding)
title('pattern padding')
axis image
[X_m, Y_m] = meshgrid(1:size(crop_pat,2), 1:size(crop_pat,1));
[X_m_pad, Y_m_pad] = meshgrid(1:size(crop_pat_padding,2), 1:size(crop_pat_padding,1));
%pat_trans = interp2(X_m,Y_m,crop_pat,X_m/10+1,Y_m/10+1);

x_hat = X_m_pad - pat_center_x;
y_hat = Y_m_pad - pat_center_y;

theta_x = atand((x_hat / x_rad ) * tand(30));
theta_y = atand((y_hat / y_rad ) * tand(28.5));
pat_trans_all = cell(9,1);

%x_pos = [-0.16, 0, 0.16,-0.16, 0, 0.16,-0.16, 0, 0.16];
%y_pos = [-0.16, -0.16, -0.16,0, 0, 0,0.16, 0.16, 0.16];
x_pos = [-0.16, 0.03, 0.16,-0.16, 0, 0.16,-0.16, -0.04, 0.16];
y_pos = [-0.16, -0.08, -0.12, 0.05, 0, -0.05, 0.12, 0.08, 0.16];
f_length = 3.00;
deg_x = atand(x_pos/f_length);
deg_y = atand(y_pos/f_length);

for idx = 1:9
    idx
    delta_x = theta_x + deg_x(idx);
    delta_y = theta_y + deg_y(idx);

    X_m_delta = tand(delta_x)/tand(30)*x_rad + pat_center_x;
    Y_m_delta = tand(delta_y)/tand(28.5)*y_rad + pat_center_y;

    %X_m_delta = padarray(X_m_delta,[pad_sz pad_sz],1,'both');
    %Y_m_delta = padarray(Y_m_delta,[pad_sz pad_sz],1,'both');

    pat_trans = interp2(X_m_pad,Y_m_pad,crop_pat_padding,X_m_delta,Y_m_delta);
    %figure
    %imagesc(pat_trans)
    %axis image

    pat_trans_all{idx} = pat_trans;
end

%%
pat_all = zeros(size(pat_trans));
for idx = 1:9
    pat_all = pat_all + pat_trans_all{idx};
end
figure
imagesc(pat_all)
axis image
