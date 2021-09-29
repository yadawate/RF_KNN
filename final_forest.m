clc;
clear;
close all;

%% Load data
% T1 = readtable('seasons0.xlsx','Sheet','winter');
% T2 = readtable('seasons0.xlsx','Sheet','spring');
% T3 = readtable('seasons0.xlsx','Sheet','summer');
% T4 = readtable('seasons0.xlsx','Sheet','autumn');
% 
% X = [T1.Air_T T1.depth T1.time;
%     T2.Air_T T2.depth T2.time;
%     T3.Air_T T3.depth T3.time;
%     T4.Air_T T4.depth T4.time];
% 
% Y = [T1.AspaltTD;T2.TDMeasured;T3.TDMeasured;T4.TDMeasured];

load new_data1.mat;
X = new_data(:,1:3);
Y = new_data(:,4);

X = X./max(X);
Y = Y./max(Y);
n = size(X,1);
num_train = floor(0.7*n);
n_idx = randperm(n,num_train);
n_tst = ~ismember(1:n,n_idx);
X_train = X(n_idx,:);
X_test = X(n_tst,:);
y_train = Y(n_idx,:);
y_test = Y(n_tst,:);

rand('state', 0);
randn('state', 0);

opts= struct;
opts.depth= 9;
opts.numTrees= 40;
opts.numSplits= 2;
numTrees= opts.numTrees; 
treeModels= cell(1, numTrees);
for i=1:numTrees
   treeModels{i} = treeTrain(X_train, y_train, opts);
end
model.treeModels = treeModels;

m= model;
y_pred = forestTest(m, X_test);

%% error values
R = corr(y_test,y_pred)
mse = sum((y_test - y_pred).^2)/length(y_test)

