% Sign function

% (C) 2011 by Georgios Fainekos (fainekos@asu.edu)
% Last update: 2012.06.22

function out = sign(inp)
if inp>0
	out = 1;
elseif inp<0
	out = -1;
else
	out = 0;
end
