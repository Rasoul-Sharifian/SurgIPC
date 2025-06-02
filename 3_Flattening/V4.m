    % The whole optimisation problem
% Our barycentric conformal term + grid
% SVD approach

clc
clear
% close all
gridsize = 30;
data_name = 'UT10';

for frmam_ind = [1:125]
path = ['../2_DataPreprocessing/' data_name '/Masked meshes gs' num2str(gridsize) '/Mesh_fram_', num2str(frmam_ind), '_3d_masked.obj'];

[v, f] = readOBJ(path) ;

% figure , plot_mesh(v,f)
% title('3d mesh')
% shading faceted; axis tight;
% pause(1)
path_img = ['../2_DataPreprocessing/' data_name '/Masked meshes gs' num2str(gridsize) '/Mesh_fram_', num2str(frmam_ind), '_img_masked.obj'];
[v_img, f_img] = readOBJ(path_img) ;
p0 = zeros(size(v_img ,1) * 2 ,1);
p0(1:2:end) = v_img(:,1);
p0(2:2:end) = v_img(:,2);

% figure , plot_mesh(v_img,f_img)
% title('3d mesh')
% shading faceted; axis tight;
% pause(1)

M = Construct_M(v , f);
I = eye(size(v,1) * 2);
counter = 940;


for lambda = .940
    tic
    mu_grid = .0050 ;
    mu_angle = .20 ;
    epsilon = .00001;
    M2 = [mu_angle * (1/(size(f,1)*3)) * lambda * M; mu_grid * (1/size(v,1)) * ((1 - lambda)) * I];
    p00 = [zeros(size(f,1) * 2 ,1);mu_grid * (1/size(v,1)) * max((1 - lambda),epsilon) * p0];

    x = inv(M2'*M2)*M2'*p00;
    % x_pinv = pinv(M2);
    toc
%     cost(counter) = sum((M2 * x - p00)' * (M2 *x - p00));
%     
%     cost_angle(counter) =  (1/(size(f,1)*3)) * (sum((M*x)'*(M*x)));
%     cost_grid(counter) =  (1/size(v,1)) *  (sum((x - p0)'*(x - p0)));

    x_show = [x(1:2:end) , x(2:2:end)];

    folderName = [ data_name '/Flattened Meshes ' 'gs' num2str(gridsize) '/Frame ', num2str(frmam_ind)];

if ~exist(folderName, 'dir')
    mkdir(folderName);
    fprintf('Folder "%s" created.\n', folderName);
else
    fprintf('Folder "%s" already exists.\n', folderName);
end
    writeOBJ([folderName ,'/lambda ' num2str(counter) '.obj'] , x_show,f)
    counter = counter +1

end

%% Flat Mask
path_img = ['../1_DataPreparation/' data_name '/Color/'];

img_filename = [path_img sprintf('%03d', frmam_ind) '.png'];
I_color = imread(img_filename);
I_mask = zeros(size(I_color,1),size(I_color,2));
P_flat = x_show(:,1:2);

options.verb = 0;
B_flat = compute_boundary(f, options);
% figure, plot(P_flat(B_flat, 1), P_flat(B_flat, 2), 'r', 'LineWidth', 4)
[X, Y] = meshgrid(1:size(I_mask, 2),1:size(I_mask, 1));

in_boundary = inpolygon(X, Y, P_flat(B_flat, 1), P_flat(B_flat, 2));
I_mask = uint8(in_boundary)*255;
% Step 4: Create binary image
figure
imshow(I_mask, []);

folderName = [data_name '/masks_flat gs' num2str(gridsize) '/Frame ', num2str(frmam_ind)];
if ~exist(folderName, 'dir')
    mkdir(folderName);
    fprintf('Folder "%s" created.\n', folderName);
else
    fprintf('Folder "%s" already exists.\n', folderName);
end
I_mask = I_mask';
imwrite(I_mask,[folderName ,'/lambda' num2str(counter-1) '.png'])
close all
end
