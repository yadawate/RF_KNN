
clc;
clear;
close all;
%% Data
% % 
% T1 = readtable('seasons0.xlsx','Sheet','winter');
% T2 = readtable('seasons0.xlsx','Sheet','spring');
% T3 = readtable('seasons0.xlsx','Sheet','summer');
% T4 = readtable('seasons0.xlsx','Sheet','autumn');
% 
% X = [T1.Air_T T1.depth T1.time;
%     T2.Air_T T2.depth T2.time;
%     T3.Air_T T3.depth T3.time;
%     T4.Air_T T4.depth T4.time];
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

%% Clustering
idx = kmeans([X_train(:,2) X_train(:,3)],40);
u_idx = unique(idx);

%% Cluster idetification using RF
rand('state', 0);
randn('state', 0);


opts= struct;
opts.depth= 9;
opts.numTrees= 100;
opts.numSplits= 2;
numTrees= opts.numTrees; 
treeModels= cell(1, numTrees);
for i=1:numTrees
   treeModels{i} = treeTrain(X_train, idx, opts);
end
model.treeModels = treeModels;
%% Loop over unique clusters
n_burnin = 1000;

for itx = 1:length(u_idx)
    X_trn = X_train(idx==u_idx(itx),:);
    Y_trn = y_train(idx==u_idx(itx));
    
    %% MH algo for time
    
    [N,p] = size(X_trn);
    beta_0 = 0;
    beta_m0 = [0 0 0]';
    sample = [];
    var_r = 0.0002;
    p_0 = beta_0 + X_trn*beta_m0;
    for i = 1:5000
        beta_t = mvnrnd(beta_0,var_r);
        beta_mt(:,1) = mvnrnd(beta_m0(1),var_r);
        beta_mt(:,2) = mvnrnd(beta_m0(2),var_r);
        beta_mt(:,3) = mvnrnd(beta_m0(3),var_r);
        beta_mt = beta_mt';
        p_t = beta_t+X_trn*beta_mt;
        u = log(rand);
        lik0 = posterior([beta_0; beta_m0(:,1)],p_0,Y_trn);
        likt = posterior([beta_t; beta_mt(:,1)],p_t,Y_trn);
        acc = likt - lik0;
        if acc >= u
            beta_0 = beta_t;
            beta_m0 = beta_mt;
            p_0 = p_t;
            sample = [sample [beta_t; beta_mt(:,1)]];
        end
    end
    rel_out = sample(:,n_burnin:end);
    r_mean(itx,:) = mean(rel_out');
end

%% test of output against test data

c_pred = forestTest(model, X_test);

for i = 1:length(c_pred)
    id_num = c_pred(i);
    r_coeff = r_mean(id_num,:);
    y_pred(i) = r_coeff(1)+X_test(i,:)*r_coeff(2:4)';
end

R = corr(y_pred',y_test)
mse = (sum((y_pred' - y_test).^2)/length(y_test))

