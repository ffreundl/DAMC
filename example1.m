M = [1 2; 3 4; 5 6]
V = [1 -1 1 1 -1]
W = [1; -1; 1; 1; -1]
size(M)
length(V)
max(V)
min(V)
unique(V)
find(V==1)
length(find(V==1))
M(1, :)
M(:, 1)
M(2:3, 1:2)
A = size(M)
%% example of struct
% a struct can have many different fields.
% ex: S is a struct of a colored surface 
S.color = 'green'; % set the color
S.area = 5; % set the area
S % show the detail of S
S.area % access and show the 'area' field of struct 'S'
S.color % access and show the 'color' field of struct 'S'