function model = forestTrain(X, Y, opts)
    numTrees= opts.numTrees; 
    treeModels= cell(1, numTrees);
    for i=1:numTrees
        treeModels{i} = treeTrain(X, Y, opts);
    end
    model.treeModels = treeModels;
end