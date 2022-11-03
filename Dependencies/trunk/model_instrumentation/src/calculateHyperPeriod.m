function [ hyperPeriod ] = calculateHyperPeriod( sampleTimeArr )
%calculateHyperPeriod Calculates hyperperiod of sample times
%Minimum allowed step size is 1 ms

try
    hyperPeriod = 1;
    calcArr = 1000*sampleTimeArr;
    
    for i = 1:numel(calcArr)
        try
            hyperPeriod = lcm(hyperPeriod, calcArr(i));
        catch
            fprintf('ERROR: calculateHyperPeriod : cannot calculate hyperperiod. Possibly not a multiple of 1ms period exists !!!\n');
        end
    end
    hyperPeriod = hyperPeriod / 1000;
catch
    error('ERROR: calculateHyperPeriod failed!');
end
end

