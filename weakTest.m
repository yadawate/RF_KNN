function yhat = weakTest(model, X)
[N, D]= size(X);
if model.classifierID== 1
    yhat = double(X(:, model.r) < model.t);
else 
    yhat= double(rand(N, 1) < 0.5);
end
end