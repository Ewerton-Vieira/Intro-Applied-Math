% Summary of the script:

% 1. The face image data is loaded from the file 'allFaces.mat'. This data includes images 
%    of various people, the number of faces per person ('nfaces'), and the dimensions 
%    of each face ('n' for height and 'm' for width).

% 2. A 6x6 grid is created to display the first face of the first 36 people.
%    - The faces are reshaped from column vectors into n-by-m images and placed into 
%      the appropriate locations in a larger matrix ('allPersons').
%    - The grid of images is displayed as a grayscale image.

% 3. A loop is set up to iterate through each person in the dataset:
%    - For each person, all of their available faces are extracted and reshaped.
%    - These faces are arranged into an 8x8 grid, and up to 64 faces per person are displayed.
%    - If there are fewer than 64 faces, the grid is only partially filled.
%    - The resulting grid of faces for each person is displayed as a grayscale image.


clear all, close all, clc
% Clears all variables, closes all figure windows, and clears the command window

load ../DATA/allFaces.mat
% Loads the data from the 'allFaces.mat' file. This file is expected to contain 
% a matrix called 'faces' and possibly other variables like 'nfaces' (number of 
% faces per person), 'n' (image height), and 'm' (image width).

allPersons = zeros(n*6, m*6);
% Creates an empty matrix to store the images of all the people. The final image
% will be composed of a grid of 6x6 smaller images (assuming there are 36 people).

count = 1; % Initializes a counter for tracking which face to use
for i = 1:6 % Loops over the rows in the 6x6 grid
    for j = 1:6 % Loops over the columns in the 6x6 grid
        allPersons(1+(i-1)*n:i*n, 1+(j-1)*m:j*m) ...
            = reshape(faces(:, 1 + sum(nfaces(1:count-1))), n, m);
        % Extracts and reshapes a face from the 'faces' matrix and places it 
        % in the appropriate position in the 'allPersons' matrix. 
        % The face is reshaped into an n-by-m image.
        % The 'sum(nfaces(1:count-1))' part ensures that the correct face is selected.

        count = count + 1; % Increments the counter to move to the next face
    end
end

figure(1), axes('position', [0 0 1 1]), axis off
% Creates a figure, sets up the axes to fill the entire figure, and turns off
% the axis labels.

imagesc(allPersons), colormap gray
% Displays the 'allPersons' matrix as an image, and sets the colormap to grayscale.

%% 

for person = 1:length(nfaces)
    subset = faces(:, 1 + sum(nfaces(1:person-1)) : sum(nfaces(1:person)));
    % Extracts a subset of faces belonging to a particular person. The
    % 'sum(nfaces(1:person-1))' and 'sum(nfaces(1:person))' determine which
    % faces belong to the current person.

    allFaces = zeros(n*8, m*8);
    % Creates an empty matrix to store the images of the faces of a single person.
    % The final image will be an 8x8 grid of face images (up to 64).

    count = 1; % Resets the count to track faces for the current person
    for i = 1:8 % Loops over the rows in the 8x8 grid
        for j = 1:8 % Loops over the columns in the 8x8 grid
            if(count <= nfaces(person))
                % If there are still faces to place for this person
                allFaces(1+(i-1)*n:i*n, 1+(j-1)*m:j*m) ...
                    = reshape(subset(:,count), n, m);
                % Extracts and reshapes a face from the 'subset' matrix and 
                % places it in the appropriate position in the 'allFaces' matrix.

                count = count + 1; % Increments the counter to move to the next face
            end
        end
    end
    
    imagesc(allFaces), colormap gray
    % Displays the 'allFaces' matrix as an image for each person, with a grayscale colormap.
end
