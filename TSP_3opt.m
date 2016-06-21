function [ tour, tourLength] = threeOpt( tour, matrix )
%{ 
3 opt - heuristic (improving method)

parameters:
- tour: any tour of the n nodes
- matrix: cost matrix of a complete graph with n nodes

returns:
- tour: a 3-opt tour
- tourLength: length of the 3-opt tour

%}   

%number of nodes
n = size(matrix,1);

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

tour = [tour(n) tour(1:n)];

tourLength = 0;
for(j=1:length(tour)-1)
    tourLength = tourLength + matrix(tour(j), tour(j+1))
end

end

