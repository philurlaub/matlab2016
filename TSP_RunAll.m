function [ output_args ] = TSP_RunAll( matrix, outputfield, axes )


    TSP_helper;

    % array that holds the processingtimes 
    processingTimes = [];

    text = get(outputfield, 'String');
    
    line = '###################################################';
    msg = sprintf('%s \n\n%s', text, line); 
   
    % Run integer programm
    [t, tl, p] = TSP_IntegerProgramm(matrix);
    processingTimes(end+1) = p;
    t = getTourStringFromIntegerProgrammTour(t);
    msg = sprintf('%s \n\n### 1) Ineger Programm: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    % Run best successor
    [t, tl, p] = TSP_BestSuccessor(matrix);
    processingTimes(end+1) = p;
    tour = t;
    msg = sprintf('%s \n\n### 2) Best Successor: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    % Run Opt 2
    [t, tl, p] = TSP_2opt(tour, matrix);
    processingTimes(end+1) = p;
    msg = sprintf('%s \n\n### 3) Opt 2: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    % Run Opt 3
    [t, tl, p] = TSP_3opt(tour, matrix);
    processingTimes(end+1) = p;
    msg = sprintf('%s \n\n### 4) Opt 3: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    
    % Run brute force only when matrix has the right size 
    if size(matrix, 1) < 11
        [t, tl, p] = TSP_BruteForce(matrix);
        processingTimes(end+1) = p;
        msg = sprintf('%s \n\n### 5) BruteForce: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
    else
        msg = sprintf('%s \n\n### 5) BruteForce: ###\n    TSP is to big for Brute Force Algorithm!', msg); 
    end 
    
    % Run christofides only when matrix has the right size 
    if size(matrix, 1) < 11
        [mst, e, t, tl, p] = TSP_Christofides(matrix);
        processingTimes(end+1) = p;
        if(tl == -1)
            msg = sprintf('%s \n\n### 6) Christofides: ###\n    Matrix does not satisfy the triangle inequality!', msg); 
        else
            msg = sprintf('%s \n\n### 6) Christofides: ###\n    Tour: %s\n    Tour length: %f\n    Processing time: %f', msg, mat2str(t), tl, p); 
        end
    else
        msg = sprintf('%s \n\n### 6) Christofides: ###\n    TSP is to big for Christofides Algorithm!', msg); 
    end 
    
    % plot processing times
    cla(axes);
    bar(processingTimes);
    
    % print to gui 
    set(outputfield, 'String', msg);

end

