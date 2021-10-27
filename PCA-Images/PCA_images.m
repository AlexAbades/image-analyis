close all; clear all; clc;
%% Read the Images

% Specify the folder name. Doesn't have to be added to path
P = "YaleSubset\";
% List folder contents that match with the specified extension (D it's an
% object that stores the information about the folder)
D = dir(fullfile(P, "*.png"));
% Count the instances on that folder
N = numel(D);

% Check that is working. Select the first image 
img = imread(fullfile(D(1).folder, D(1).name));
figure;
imshow(img)

%% Ex 1
%{
Create a data matrix that has the dimensions M x N, where N is the
number of faces and M is the number of measurements per face (the number
of pixels in one image). The data matrix should be created using the Matlab
function zeros
%}

% Get size dimensions
[C, R] = size(img);

% Create a matrix to store the vectorized images 
M = zeros(C*R, N);

%% Vecotorize imges 

for i=1:N
    img = imread(fullfile(D(i).folder, D(i).name));
    tt = reshape(img, C*R, 1);
    M(:,i) = tt;
end

%% Substract means 

mu = mean(M,2);
    
% Reshape the means to a original shape image 
Imu = reshape(mu, C, R);

% Show average face 
imshow(I, []); % Specify a grey scale

%% Apply PCA (given funtion) 

[Vecs, Vals, Psi] = pc_evectors(M, 30);

%% Plot variance of each component 

Vals_n = Vals/sum(Vals);
Vals_c = cumsum(Vals_n);

figure()
subplot(1,2,1) 
plot(Vals);
grid minor
xlabel('Principal component');
ylabel('Eigenvalues');
title('Scree Plot');
legend('Eigenvalues')

subplot(1,2,2)
hold on 
plot(Vals_n)
plot(Vals_c)
yline(0.9, 'black--')
grid minor
xlabel('Principal component');
ylabel('Variance explained value');
title('Variance explained by principal components');
legend({'Individual','Cumulative','Threshold'}, ...
        'Location','best');


% How much variance explains the 2 first compoenents 
a = (Vals_n(1) + Vals_n(2))*100;
disp(a)

%% Check what exactly does each eigen vector 

% Specify the number of PCA
k = 2;

% Calculate the number of subplots given the number of PCA
N1 = ceil(sqrt(k));
N2 = ceil(k/N1);

figure()
for i = 1:k
    PCA = reshape(Vecs(:,i), C, R);
    subplot(N1, N2, i)
    imshow(PCA, [])
    title(sprintf('PCA  %u', i))
end

%% 
PCA1 = reshape(Vecs(:,1), C, R);
PCA2 = reshape(Vecs(:,2), C, R);

figure()
subplot(2,2,1)
imshow(PCA1, [])
title('PCA 1')
subplot(2,2,3)
imshow(-PCA1, [])
title('-PCA 1')

subplot(2,2,2)
imshow(PCA2, [])
title('PCA 2')
subplot(2,2,4)
imshow(-PCA2, [])
title('-PCA 2')

% We can see that PCA1 tries to explain the variance on the nose
% PCA2 explains some of the variantion of the mouth and the eyebrows


%% Create a new sinthetic image

% Create the betas and interception value 
B0 = Imu;
B1 = 1000;
B2 = -3000;
%  1000 * PCA1 - 3000 * PCA2 + meanI;
newface = B0 + B1*PCA1 + B2*PCA2;
figure()
subplot(1,2,1)
imshow(newface, []);


new =  1000 * Vecs(:, 1) - 3000 * Vecs(:, 2) + mu;
subplot(1,2,2)
imshow(reshape(new, C,R), [])

%% Create new face 
PCA3 = reshape(Vecs(:,3), C, R);
PCA4 = reshape(Vecs(:,4), C, R);
PCA5 = reshape(Vecs(:,5), C, R);

B0 = Imu;
B1 = 6000;
B2 = 2000;
B3 = 9000;
B4 = -3000;
B5 = 1000;

newface2 = B0 + B1*PCA1 + B2*PCA2 + B3*PCA3 + B4*PCA4 + B5*PCA5;
figure()
imshow(newface2, []);


