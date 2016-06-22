function [ tour, tourLength, processingTime] = threeOpt( tour, matrix )
%{ 
3 opt - heuristic (improving method)

parameters:
- tour: any tour of the n nodes
- matrix: cost matrix of a complete graph with n nodes

returns:
- tour: a 3-opt tour
- tourLength: length of the 3-opt tour
- processingTime: time for the calculation of the tour

%}

% start measuring the processing time
tic

M = 10e+06;
% Relaxation - if there is no edge between two nodes, this edge get
% expensiv costs, so if will not be taken
for(r = 1:size(matrix,1))
    for(c = 1:size(matrix,2))
        if(r~=c && matrix(r,c)==0)
            matrix(r,c) = M;
        end
    end
end

%number of nodes
n = size(matrix,1);

% check if start solution has enough entries
if(length(tour)-1 ~= n)
    %disp('Start solution includes to less or to much nodes!');
    tour = [];
    tourLength = -1;
    % stop measuring the processing time
    processingTime = toc;
    return;
end

newIteration = true;
while(newIteration)
    newIteration = false;
    
    for(z=1:n)
        for(h=1:n-3)
            for(j=h+1:n-1)
                d = matrix(tour(n),tour(1)) + matrix(tour(h), tour(h+1))+ matrix(tour(j), tour(j+1));
                d1 = matrix(tour(h),tour(j+1)) + matrix(tour(1), tour(j));
                d2 = matrix(tour(1),tour(j+1)) + matrix(tour(h), tour(j)); 

                if(d1 <= d2)
                    if((d1 + matrix(tour(h+1), tour(n))) < d)
                        % new Tour
                        % nodes 1 to h will be added in the same order to the new tour
                        % nodes j+1 to n will be added in the same order to the new tour
                        % nodes h+1 to j will be added in the same order to the new tour
                        % nodes 1 will be added in the same order to the new tour
                        tour = [tour(1:h) tour(j+1:n) tour(h+1:j) tour(1)];
                        newIteration = true;
                        break;
                    end
                else
                    if((d2 + matrix(tour(h+1), tour(n))) < d)
                        % new Tour
                        % nodes 1 will be added in the same order to the new tour
                        % nodes j+1 to n will be added in the same order to the new tour
                        % nodes h+1 to j will be added in the same order to the new tour
                        % nodes 1 will be added in the reverse order to the new tour
                        tour = [tour(1) tour(j+1:n) tour(h+1:j) tour(h:-1:1)];
                        newIteration = true;
                        break;
                    end
                end
            end
            if(newIteration)
                break;
            end
        end
        
        if(newIteration)
            break;
        end
        
        %Rotation
        tour = [tour(n) tour(1:n)];
    end
end

tourLength = 0;
for(j=1:length(tour)-1)
    tourLength = tourLength + matrix(tour(j), tour(j+1));
end

% stop measuring the processing time
processingTime = toc;

end

