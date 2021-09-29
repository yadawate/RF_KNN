function [Yhard, Ysoft] = treeTest(model, X)
d= model.depth;
[N, D]= size(X);
nd= 2^d - 1;
numInternals = (nd+1)/2 - 1;
numLeafs= (nd+1)/2;

Yhard= zeros(N, 1);
u= model.classes;
dataix= zeros(N, nd); 
for n = 1: numInternals
    if n==1 
        reld = ones(N, 1)==1;
        Xrel= X;
    else
        reld = dataix(:, n)==1;
        Xrel = X(reld, :);
    end
    if size(Xrel,1)==0, continue; end 
    yhat= weakTest(model.weakModels{n}, Xrel);    
    dataix(reld, 2*n)= yhat;
    dataix(reld, 2*n+1)= 1 - yhat; 
end

for n= (nd+1)/2 : nd
    ff= find(dataix(:, n)==1);
    
    hc= model.leafdist(n - (nd+1)/2 + 1, :);
    vm= max(hc);
    miopt= find(hc==vm);
    mi= miopt(randi(length(miopt), 1)); 
    Yhard(ff)= u(mi);
    
    if nargout > 1
        Ysoft(ff, :)= repmat(hc, length(ff), 1);
    end
end
