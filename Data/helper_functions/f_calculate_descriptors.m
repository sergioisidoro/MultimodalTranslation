function [ descriptors ] = f_calculate_descriptors(skeleton, coordinate_data, bvh_data, selected_descriptors)
%F_CALCULATE_DESCRIPTORS Descriptor values for each frame of motion
%   f_calculate_descriptors(skeleton, coordinate_data, bvh_data, selected_descriptors, descriptor_bands)
%   Descriptor families: 
%       velocities
%       distances
%       directions
%       positions
%       accelerations
%       Euler angles
%       quaternions
%       Euler angle velocities
%       rotational velocities (ona value per joint)

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

%%

% Height is used in scaling the descriptors.
height = 0.0;
for i = [2 3 4 5 6 22 23 24]
    height = height + sum(abs(skeleton.tree(i).offset * [0 1 0]'));
end

% Without the height based scaling:
%   Scaling the skeleton 0.9 to 1.1 does not affect classification much.
%   Scaling the skeleton by 0.5 makes most frames classified to sitting.
%   Scaling the skeleton by 1.5 makes most frames classified to jumping.

dimensions = size(coordinate_data);

%% Calculation of velocity for each marker

if selected_descriptors(1) || selected_descriptors(5)
    
    velocities = zeros(dimensions(1), dimensions(2)/3);
    for i1 = 1 : dimensions(1) - 1
        for i2 = 1 : 3 : dimensions(2)
            velocities(i1, (i2+2)/3) =  sqrt( ...
                (coordinate_data(i1, i2+0) - coordinate_data(i1+1, i2+0))^2 ...
                + (coordinate_data(i1, i2+1) - coordinate_data(i1+1, i2+1))^2 ...
                + (coordinate_data(i1, i2+2) - coordinate_data(i1+1, i2+2))^2 ...
                );
        end
    end
    
    % Neck, LeftCollar and RigthCollar are duplicates of each other
    velocities(:, 12) = [];
    velocities(:, 7) = [];
    
    
    velocities(dimensions(1), :) = velocities(dimensions(1) - 1, :);
    
    velocities = velocities * (100 / height);
    
%     figure(1);
%     plot(velocities(:,24), 'b');
%     hold on;
    
    % Median filtering seems to remove false spikes from velocity
    velocities = medfilt1(velocities, 9);
    
%     plot(velocities(:,24), 'r');
%     hold off;
    
end

%% Distances between body parts
% all body parts:
%
% Hips Ab Chest Neck Head HeadEnd LeftCollar LeftShoulder LeftElbow LeftWrist LeftHandEnd RightCollar RightShoulder RightElbow RightWrist RightHandEnd LeftHip LeftKnee LeftAnkle LeftFootEnd RightHip RightKnee RightAnkle RightFootEnd
%
% Find combinations between: Hips Neck HeadEnd LeftElbow LeftHandEnd RightElbow RightHandEnd LeftKnee LeftFootEnd RightKnee RightFootEnd

if selected_descriptors(2)
    
    clear list;
    parts = [ 1 4 6 9 11 14 16 18 20 22 24 ];
    count = 1;
    for i1 = 1 : length(parts)
        for i2 = i1 + 1 : length(parts)
            list(count, :) = [parts(i1) parts(i2)];
            count = count + 1;
        end
    end
    
    % Calculate distances between the body part combinations
    distances = zeros(dimensions(1), length(list));
    for i1 = 1 : dimensions(1)
        for i2 = 1 : length(list)
            a = (list(i2, 1) * 3) - 2;
            b = (list(i2, 2) * 3) - 2;
            distances(i1, i2) = sqrt( ...
                (coordinate_data(i1, a+0) - coordinate_data(i1, b+0))^2 ...
                + (coordinate_data(i1, a+1) - coordinate_data(i1, b+1))^2 ...
                + (coordinate_data(i1, a+2) - coordinate_data(i1, b+2))^2 ...
                );
        end
    end
    
    distances = distances / 100.0;
    
    distances = distances * (100 / height);
    
end

%% Direction of motion from the last frame on the x, y and z axes
% The character is rotated to make the positive z axis same as the facing
% direction.

% For: all body parts

if selected_descriptors(3)
    
    % Note: Neck, LeftCollar and RigthCollar are duplicates of each other
    parts = [1 2 3 4 5 6 8 9 10 11 13 14 15 16 17 18 19 20 21 22 23 24];
    parts = (parts * 3) - 2;
    
    directions = zeros(dimensions(1), length(parts) * 3);
    
    for i1 = 1 : dimensions(1) - 1
        transformation = bvh_data(i1, 1:3);
        rotation = f_rotationmat3D((bvh_data(i1, 6) / 180) * pi, [ 0 1 0]); % Gimbal lock may break this
        
        frameA = coordinate_data(i1, :);
        frameB = coordinate_data(i1+1, :);
        
        for i2 = 1 : length(parts)
            frameA(parts(i2) : parts(i2)+2) = frameA(parts(i2) : parts(i2)+2) - transformation;
            frameA(parts(i2) : parts(i2)+2) = frameA(parts(i2) : parts(i2)+2) * rotation;
            frameB(parts(i2) : parts(i2)+2) = frameB(parts(i2) : parts(i2)+2) - transformation;
            frameB(parts(i2) : parts(i2)+2) = frameB(parts(i2) : parts(i2)+2) * rotation;
            directions(i1, (i2*3)-2 : i2*3) = frameB(parts(i2) : parts(i2)+2) - frameA(parts(i2) : parts(i2)+2);
        end
    end
    
    directions(dimensions(1), :) = directions(dimensions(1) - 1, :);
    
    directions = directions * (100 / height);
    
%     figure(2);
%     plot(directions(:,1), 'b');
%     hold on;
    
    % Median filtering seems to remove false spikes from velocity
    directions = medfilt1(directions, 7);
    
%     plot(directions(:,1), 'r');
%     hold off;
    
end

%% Partially normalized positions
% The character is rotated to make the positive z axis same as the facing
% direction and moved to origin along z and x axes, but not along y axis.

% For: all body parts

if selected_descriptors(4)
    
    % Note: Neck, LeftCollar and RigthCollar are duplicates of each other
    parts = [1 2 3 4 5 6 8 9 10 11 13 14 15 16 17 18 19 20 21 22 23 24];
    parts = (parts * 3) - 2;
    
    positions = zeros(dimensions(1), length(parts) * 3);
    
    for i1 = 1 : dimensions(1)
        transformation = [bvh_data(i1, 1) 0  bvh_data(i1, 3)];
        rotation = f_rotationmat3D((bvh_data(i1, 6) / 180) * pi, [ 0 1 0]); % Gimbal lock may break this
        
        frame = coordinate_data(i1, :);
        
        for i2 = 1 : length(parts)
            frame(parts(i2) : parts(i2)+2) = frame(parts(i2) : parts(i2)+2) - transformation;
            frame(parts(i2) : parts(i2)+2) = frame(parts(i2) : parts(i2)+2) * rotation;
            
            positions(i1, (i2*3)-2 : i2*3) = frame(parts(i2) : parts(i2)+2);
        end
    end
    
    positions(:, 3) = []; % has only zeros
    positions(:, 1) = []; % has only zeros
    positions = positions / 100;
    
    positions = positions * (100 / height);
    
end

%% Accelerations, absolute values

if selected_descriptors(5)
    
    dim_vel = size(velocities);
    accelerations = zeros(dim_vel);
    for i1 = 1 : dim_vel(1) - 1
        for i2 = 1 : dim_vel(2)
            accelerations(i1, i2) =  abs(velocities(i1, i2) - velocities(i1+1, i2));
        end
    end

    
    % Accelerations need to be lowpass filtered to get rid of the noise
    % Filter designed with filterbuilder, pass 10Hz, stop 30Hz
    b = [
        -0.0087
        -0.0295
        -0.0310
        0.0433
        0.1964
        0.3303
        0.3303
        0.1964
        0.0433
        -0.0310
        -0.0295
        -0.0087
        ];
    a = 1;
    accelerations  = filter(b, a, accelerations);
    
    % fixing the delay
    accelerations(1 : length(accelerations) - 5, :) = accelerations(1+5 : length(accelerations), :);
    accelerations(length(accelerations) - 4 : length(accelerations), :) = zeros(5, size(accelerations, 2));
    
%     figure(1);
%     hold on;
%     plot(accelerations(:,24) * 10, 'k');
    
end

%% Euler angles

if selected_descriptors(6)
    angles = bvh_data(:, 7:60) / 180;
end

%% Quaternions

if selected_descriptors(7) || selected_descriptors(9)
    %     quaternions = zeros(size(bvh_data, 1), 72);
    %     for i = 1 : 18
    %         quaternions(:, (i-1)*4+1:(i-1)*4+4) = f_SpinCalc('EA312toQ', bvh_data(:, (i-1)*3+7:(i-1)*3+9), 0.0001, 0);
    %     end
    quaternions = zeros(size(bvh_data, 1), 72);
    for i = 1 : 18
        quaternions(:, (i-1)*4+1:(i-1)*4+4) = f_SpinCalc('EA312toQ', bvh_data(:, (i-1)*3+7:(i-1)*3+9), 0.0001, 0);
        
        % This should fix all the jumps in quaternion values between the motions
        for i2 = 1 : size(bvh_data, 1)
            if (quaternions(i2, (i-1)*4+4) < 0)
                quaternions(i2, (i-1)*4+1:(i-1)*4+4) = quaternions(i2, (i-1)*4+1:(i-1)*4+4) * -1;
            end
        end
        
    end
end

%% Euler angle velocities

if selected_descriptors(8)
    Euler_angle_velocities = zeros(size(bvh_data, 1), (size(bvh_data, 2) - 3));
    for i = 1 : size(bvh_data, 1) - 1
        Euler_angle_velocities(i, :) = bvh_data(i, 4:60) - bvh_data(i+1, 4:60);
    end
    
    % Median filtering seems to remove false spikes from velocity
    Euler_angle_velocities = medfilt1(Euler_angle_velocities, 5);
end

%% Rotational velocities

if selected_descriptors(9)
    rotational_velocities = zeros(size(bvh_data, 1), 18);
    quat_changes = zeros(size(quaternions));
    for i = 1 : size(bvh_data, 1) - 1
        quat_changes(i, :) = quaternions(i, :) - quaternions(i+1, :);
    end
    
    for i = 0 : 17
        rotational_velocities(:, i+1) = ...
            abs(quat_changes(:, (i*3)+1)) +  ...
            abs(quat_changes(:, (i*3)+2)) +  ...
            abs(quat_changes(:, (i*3)+3)) +  ...
            abs(quat_changes(:, (i*3)+4));
    end
    
     % Median filtering seems to remove false spikes from velocity
    rotational_velocities = medfilt1(rotational_velocities, 5);
end

%% Put everything together

descriptors = [];
if selected_descriptors(1)
    descriptors = concatenate_descriptors(descriptors, velocities);
end
if selected_descriptors(2)
    descriptors = concatenate_descriptors(descriptors, distances);
end
if selected_descriptors(3)
    descriptors = concatenate_descriptors(descriptors, directions);
end
if selected_descriptors(4)
    descriptors = concatenate_descriptors(descriptors, positions);
end
if selected_descriptors(5)
    descriptors = concatenate_descriptors(descriptors, accelerations);
end
if selected_descriptors(6)
    descriptors = concatenate_descriptors(descriptors, angles);
end
if selected_descriptors(7)
    descriptors = concatenate_descriptors(descriptors, quaternions);
end
if selected_descriptors(8)
    descriptors = concatenate_descriptors(descriptors, Euler_angle_velocities);
end
if selected_descriptors(9)
    descriptors = concatenate_descriptors(descriptors, rotational_velocities);
end

end

%% helper functions

function [new_array] = concatenate_descriptors(old_stuff, new_stuff)
    if isempty(old_stuff)
        new_array = new_stuff;
    else
        new_array = [old_stuff new_stuff];
    end
end
