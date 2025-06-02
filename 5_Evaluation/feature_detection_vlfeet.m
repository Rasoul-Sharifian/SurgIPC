function [key_points_masked, descriptors_masked] = feature_detection_vlfeet(path_img , path_mask, mask_exist)

    I_rgb = imread(path_img);
    I = single(rgb2gray(I_rgb));

    if mask_exist==1
        mask = imread(path_mask);
        radius = 25;
        se = strel('disk', radius);
        mask = imerode(mask', se);
    else
        mask = imread(path_mask);
        radius = 16;
        se = strel('disk', radius);
        mask = imerode(mask, se);
        % grayImage = rgb2gray(I_rgb);
        % threshold = 230; % Adjust as needed
        % binaryMask = grayImage < threshold;
        % filledMask = imfill(binaryMask, 'holes');
        % se = strel('disk', 3); % Adjust the radius as needed
        % mask = imopen(filledMask, se);
        % 
        % radius = 6;
        % se = strel('disk', radius);
        % mask = imerode(mask, se);
        % 
        % frame_number = path_img(end-14:end-14)
        % 
        % [P_flat, f_flat] = readOBJ(['../3_Flattening/' data_name '/Flattened Meshes gs' num2str(gridsize), ...
        %     '/Frame ' (frame_number) '/lambda ' num2str(lambda) '.obj']);
        % P_flat = P_flat(:,1:2);
        % options.verb = 0;
        % B_flat = compute_boundary(f_flat, options);
        % figure, plot(P_flat(B_flat, 1), P_flat(B_flat, 2), 'r', 'LineWidth', 4)
        % [X, Y] = meshgrid(1:size(I, 2),1:size(I, 1));
        % 
        % in_boundary = inpolygon(X, Y, P_flat(B_flat, 1), P_flat(B_flat, 2));
        % I_mask = uint8(in_boundary);
        % I_mask = I_mask == 1;
        % I_mask = imerode(I_mask, se);

    end

    % radius = 40;
    % se = strel('disk', radius);
    % mask = imerode(mask, se);


    % [key_points, descriptors] = vl_covdet(I, 'Method', 'Hessian', 'EstimateAffineShape', true, 'descriptor', 'sift');
    % % L1-Normalize the SIFT descriptors
    % d_norm = bsxfun(@rdivide, descriptors, sum(abs(descriptors)));   
    % % Apply the square root to each element
    % % 'd_rootSIFT' now contains the RootSIFT descriptors
    % d_rootSIFT = sqrt(d_norm);
    % descriptors = d_rootSIFT;
    
    [key_points, descriptors] = vl_sift(I) ;

    if islogical(mask) == 0
        [x,y] = find (mask == 255);
    else
        [x,y] = find (mask == 1);
    end

    locations = [y,x];

    % Filter keypoints to only include those at the specified locations
    points_rounded = round(key_points)';
    points_rounded = points_rounded(:, 1:2);
    key_points_masked = key_points(:,ismember(points_rounded, locations, 'rows'));
    descriptors_masked = descriptors(:,ismember(points_rounded, locations, 'rows')); 
end
