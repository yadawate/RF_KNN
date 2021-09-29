function [Yhard, Ysoft] = forestTest(model, X)
    numTrees= length(model.treeModels);
    u= model.treeModels{1}.classes; 
    Ysoft= zeros(size(X,1), length(u));
    for i=1:numTrees
        [~, ysoft] = treeTest(model.treeModels{i}, X);
        Ysoft= Ysoft + ysoft;
    end
    
    Ysoft = Ysoft/numTrees;
    [~, ix]= max(Ysoft, [], 2);
    Yhard = u(ix);
end
