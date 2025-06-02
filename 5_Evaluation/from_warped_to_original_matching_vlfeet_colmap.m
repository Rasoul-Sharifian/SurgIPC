function [frompixel_wp, error_point] = from_warped_to_original_matching_vlfeet(data_name,key_points_other_view, main_path, ...
    other_view_frame_nb, lambda, convex, lambda_nonconvex, gridsize)

if convex == 0
    [vflat , fflat] = readOBJ(['../3_Flattening/' data_name '/Flattened Meshes gs' num2str(gridsize) ...
        num2str(other_view_frame_nb) '/0' num2str(lambda_nonconvex) '.obj']);
else
    [vflat , fflat] = readOBJ(['../3_Flattening/' data_name '/Flattened Meshes gs' num2str(gridsize) '/Frame ' ...
        num2str(other_view_frame_nb) '/lambda ' num2str(lambda) '.obj']);
end

vflat = vflat';
vflat_new(1,:) = vflat(1,:);%round(1/1000 * (vflat(1,:) - min(vflat(1,:))) * size(Ia , 1));
vflat_new(2,:) = vflat(2,:);%round(1/1000 * (vflat(2,:) - min(vflat(2,:))) * size(Ia , 2));

counter_wp = 1;

[vimg , fimg] = readOBJ(['../2_DataPreprocessing/' data_name '/Masked meshes gs' num2str(gridsize) ...
    '/Mesh_fram_' num2str(other_view_frame_nb) '_img_masked.obj']);%

vimg = vimg';
fimg = fimg';
fflat = fflat';
error_point =[];
counter2 = 1;
Px = [];
Py = [];
for wp = 1:size(key_points_other_view,2)
    xq = double(key_points_other_view(1,wp));%points_selected.Location(:,1);
    yq = double(key_points_other_view(2,wp));

    for T = 1:size(fflat,2)
        Vo1 = vimg(1:2,fimg(1,T)); % Cartesian coordinates of the first vertex in output image
        Vo2 = vimg(1:2,fimg(2,T)); % Cartesian coordinates of the secend vertex in output image
        Vo3 = vimg(1:2,fimg(3,T)); % Cartesian coordinates of the third vertex in output image
        Vo = [Vo1 Vo2 Vo3 Vo1];

        Vi1 = vflat_new(1:2,fflat(1,T)); % Cartesian coordinates of the first vertex in input image
        Vi2 = vflat_new(1:2,fflat(2,T)); % Cartesian coordinates of the secend vertex in input image
        Vi3 = vflat_new(1:2,fflat(3,T)); % Cartesian coordinates of the third vertex in input image
        Vi = [Vi1 Vi2 Vi3 Vi1];

        xi = Vi(1,:)';
        yi = Vi(2,:)';

        in_on = inpolygon(xq, yq,xi, yi);

        [w1,w2,w3,r] = inTri(xq, yq, xi(1), yi(1), xi(2), yi(2), xi(3), yi(3));

        [xs1, ys1] = find(in_on==1);
        id = find(in_on==1);

        xs1 = xs1(:);
        ys1 = ys1(:);

        C = [xq(in_on), yq(in_on)];

        VertexOut = [Vo1 Vo2 Vo3];
        temp_Fo = [1 , 2 , 3];

        VertexIn = [Vi1 Vi2 Vi3];
        temp_Fi = [1 , 2 , 3];

        TRo = triangulation(temp_Fo,VertexOut');
        TR_Flat = triangulation(temp_Fi,VertexIn');

        if C~=0
            B = cartesianToBarycentric(TR_Flat,ones(1,size(C,1))',C);
            Px(wp) = B(:,1) * VertexOut(1,1) + B(:,2) * VertexOut(1,2) + B(:,3) * VertexOut(1,3);
            Py(wp) = B(:,1) * VertexOut(2,1) + B(:,2) * VertexOut(2,2) + B(:,3) * VertexOut(2,3);
            scale(wp) = double(key_points_other_view(3,wp));
            orientation(wp) = double(key_points_other_view(4,wp));
            wp;
            counter_wp;
            counter_wp = counter_wp +1;

            kk = 5;
        


        end
        clear C

    end

    % if counter_wp ~= wp + 1 && counter2 == 1
    %     error_point = wp
    %     counter2 = 2
    % end
end

frompixel_wp = [Px',Py',scale', orientation'];
% frompixel_wp = round(frompixel_wp);

end
function [w1,w2,w3,r] = inTri(vx, vy, v0x, v0y, v1x, v1y, v2x, v2y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inTri checks whether input points (vx, vy) are in a triangle whose
% vertices are (v0x, v0y), (v1x, v1y) and (v2x, v2y) and returns the linear
% combination weight, i.e., vx = w1*v0x + w2*v1x + w3*v2x and
% vy = w1*v0y + w2*v1y + w3*v2y. If a point is in the triangle, the
% corresponding r will be 1 and otherwise 0.
%
% This function accepts multiple point inputs, e.g., for two points (1,2),
% (20,30), vx = (1, 20) and vy = (2, 30). In this case, w1, w2, w3 and r will
% be vectors. The function only accepts the vertices of one triangle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    v0x = repmat(v0x, size(vx,1), size(vx,2));
    v0y = repmat(v0y, size(vx,1), size(vx,2));
    v1x = repmat(v1x, size(vx,1), size(vx,2));
    v1y = repmat(v1y, size(vx,1), size(vx,2));
    v2x = repmat(v2x, size(vx,1), size(vx,2));
    v2y = repmat(v2y, size(vx,1), size(vx,2));
    w1 = ((vx-v2x).*(v1y-v2y) - (vy-v2y).*(v1x-v2x))./...
    ((v0x-v2x).*(v1y-v2y) - (v0y-v2y).*(v1x-v2x))+eps;
    w2 = ((vx-v2x).*(v0y-v2y) - (vy-v2y).*(v0x-v2x))./...
    ((v1x-v2x).*(v0y-v2y) - (v1y-v2y).*(v0x-v2x))+eps;
    w3 = 1 - w1 - w2;
    r = (w1>=-100*eps) & (w2>=-100*eps) & (w3>=-100*eps) & ...
    (w1<=1+100*eps) & (w2<=1+100*eps) & (w3<=1+100*eps);
end
