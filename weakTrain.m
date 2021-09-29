function model = weakTrain(X, Y)
numSplits= 2;
u= unique(Y);
[N, D]= size(X);
if N == 0
    model.classifierID= 0;
    return;
end
bestgain= -100;
model = struct;
modelCandidate= struct;
maxgain= -1;
for q= 1:numSplits
    
    if mod(q-1,5)==0
        r= randi(D);
        col= X(:, r);
        tmin= min(col);
        tmax= max(col);
    end
    
    t= rand(1)*(tmax-tmin)+tmin;
    dec = col < t;
    Igain = evalDecision(Y, dec, u);
    
    if Igain>maxgain
        maxgain = Igain;
        modelCandidate.r= r;
        modelCandidate.t= t;
    end
end

if maxgain >= bestgain
    bestgain = maxgain;
    model= modelCandidate;
    model.classifierID= 1;
end
end

function Igain= evalDecision(Y, dec, u)
YL= Y(dec);
YR= Y(~dec);
H= classEntropy(Y, u);
HL= classEntropy(YL, u);
HR= classEntropy(YR, u);
Igain= H - length(YL)/length(Y)*HL - length(YR)/length(Y)*HR;

end

function H= classEntropy(y, u)
cdist= histc(y, u) + 1;
cdist= cdist/sum(cdist);
cdist= cdist .* log(cdist);
H= -sum(cdist);
end
