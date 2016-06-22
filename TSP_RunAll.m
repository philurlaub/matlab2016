function [ output_args ] = TSP_RunAll( matrix, outputfield, axes )
%TSP_RUNALL Summary of this function goes here
%   Detailed explanation goes here

    TSP_helper;

    processingTimes = [];

    text = get(outputfield, 'String');
    
    line = '###################################################';
    msg = sprintf('%s \n\n%s', text, line); 
   
    [t, tl, p] = TSP_IntegerProgramm(matrix);
    processingTimes(end+1) = p;
    t = getTourStringFromIntegerProgrammTour(t);
    msg = sprintf('%s \n\n### 1) Ineger Programm: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    [t, tl, p] = TSP_BestSuccessor(matrix);
    processingTimes(end+1) = p;
    tour = t;
    msg = sprintf('%s \n\n### 2) Best Successor: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    [t, tl, p] = TSP_2opt(tour, matrix);
    processingTimes(end+1) = p;
    msg = sprintf('%s \n\n### 3) Opt 2: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    [t, tl, p] = TSP_3opt(tour, matrix);
    processingTimes(end+1) = p;
    msg = sprintf('%s \n\n### 4) Opt 3: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    if size(matrix, 1) < 11
        [t, tl, p] = TSP_BruteForce(matrix);
        processingTimes(end+1) = p;
        msg = sprintf('%s \n\n### 5) BruteForce: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    end 
    
    bar(processingTimes);
    
    set(outputfield, 'String', msg);

end

