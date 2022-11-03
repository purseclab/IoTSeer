% piecewise_const - Generates a piecewise constant signal.
% Currently piecewise_const only supports 1D signals.
%
% The interface of piecewise_const is the same as with interp1.
%
% yi = piecewise_const(x,y,xi)
%
% INPUTS: 
% x - a vector of x coordinates such that anywhere between x(i) and x(i+1) 
%     the output value is y(i)
% y - the y coordinate of the vector
% xi - a vector with x coordinates where we would like to get the y value
%
% See also: interp1

% (C) 2010 Georgios Fainekos - Arizona State University

function yi = piecewise_const(x,y,xi)
nx = length(x);
yi = zeros(size(xi));
jj = 1;
ii = 1;
while ii<=length(xi)
    if xi(ii)<x(jj)
        if jj==1
            yi(ii) = y(1);
        else
            yi(ii) = y(jj-1);
        end
        ii = ii+1;
    else
        jj = jj+1;
        if jj>nx
            yi(ii:end) = y(end);
            return
        else
            assert(x(jj-1)<x(jj), ' piecewise_const : x vector is not monotonically increasing!')
        end
    end
end
