clc;
clear;
close all;

%% dataset Load data
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

%% MH algo

[N,p] = size(X_train);
beta_0 = 0;
beta_m0 = [0 0 0]';
sample = [];
var_r = 0.0003;
p_0 = beta_0 + X_train*beta_m0;
for i = 1:10000
    beta_t = mvnrnd(beta_0,var_r);
    beta_mt(:,1) = mvnrnd(beta_m0(1),var_r);
    beta_mt(:,2) = mvnrnd(beta_m0(2),var_r);
    beta_mt(:,3) = mvnrnd(beta_m0(3),var_r);
    beta_mt = beta_mt';
    p_t = beta_t+X_train*beta_mt;
    u = log(rand);
    lik0 = posterior([beta_0; beta_m0(:,1)],p_0,y_train);
    likt = posterior([beta_t; beta_mt(:,1)],p_t,y_train);
    acc = likt - lik0;
    if acc >= u
        beta_0 = beta_t;
        beta_m0 = beta_mt;
        p_0 = p_t;
        sample = [sample [beta_t; beta_mt(:,1)]];
    end
end
% 
% for i = 1:length(sample)
%     y_pr = sample(1,i) + X_train*sample(2:4,i);
%     acr(i) = corr(y_train,y_pr);
% end
% 
% plot(acr);

r_coeff = mean(sample(:,100:end)')';
y_pred = r_coeff(1) + X_test*r_coeff(2:4);
R = corr(y_pred,y_test)
mse = (sum((y_pred - y_test).^2)/length(y_test))