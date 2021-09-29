function model = treeTrain(X, Y, opts)
d= opts.depth; 
u= unique(Y);
[N, D]= size(X);
nd = 2^d - 1;
numInternals = (nd+1)/2 - 1;
numLeafs= (nd+1)/2;
weakModels= cell(1, numInternals); 
dataix= zeros(N, nd);     
leafdist= zeros(numLeafs, length(u));
for n = 1: numInternals
    if n==1 
        reld = ones(N, 1)==1;
        Xrel= X;
        Yrel= Y;
    else
        reld = dataix(:, n)==1;
        Xrel = X(reld, :);
        Yrel = Y(reld);
    end
    weakModels{n}= weakTrain(Xrel, Yrel);
    yhat= weakTest(weakModels{n}, Xrel);
    dataix(reld, 2*n)= yhat;
    dataix(reld, 2*n+1)= 1 - yhat; 
end

for n= (nd+1)/2 : nd
    reld= dataix(:, n);
    hc = histc(Y(reld==1), u);
    hc = hc + 1; 
    leafdist(n - (nd+1)/2 + 1, :)= hc / sum(hc);
end

model.leafdist= leafdist;
model.depth= d;
model.classes= u;
model.weakModels= weakModels;
end
