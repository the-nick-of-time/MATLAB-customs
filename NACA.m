function [x, y, dyc_dx] = NACA(num, c, N)
	% Calculates points on a NACA 4-digit airfoil
	% Inputs
	% 	num [4-digit number]: The identifying number of the aoirfoil, i.e. 2412
	% 	c [number]: The chord length
	% 	N [integer]: the number of panels that is desired
	% Outputs
	% 	x [1 x N+1 numeric]: The chord-wise coordinates of the boundary points selected on the airfoil. The trailing edge is included twice.
	% 	y [1 x N+1 numeric]: The thickness-wise coordinates of the boundary points selected on the airfoil. The trailing edge is included twice.
	% 	dyc_dx [1 x N/2 numeric]: The slope of the camber line along every panel.
	t = mod(num, 100) / 100;
	l = mod(floor(num / 100), 10) / 10;
	m = floor(num / 1000) / 100;

	theta = linspace(0, -2*pi, N+1);
	% x = linspace(0, c, N/2);
	x = 0.5*c*(1 + cos(theta));
	yt = zeros(size(x));
	yc = zeros(size(x));

	coefficients = [.2969 -.1260 -.3516 .2843 -.1036];
	powers = [1/2 1 2 3 4];
	for i = 1:length(x)
		yt(i) = sum(5*t*c*(coefficients .* (x(i)/c) .^ powers));
		if x(i) <= l*c && m
			yc(i) = m * x(i) / (l^2) * (2*l - x(i)/c);
		else
			yc(i) = m * (c-x(i)) / (1-l)^2 * (1 + x(i)/c - 2*l);
		end
	end
	dyc = diff([yc 0]);
	dx = diff([x c]);
	zeta = atan2(dyc, dx);

	% Proceeds from the trailing edge around the bottom of the airfoil and back around the top
	x = x - yt .* sign(sin(theta)) .* sin(zeta);
	y = yc + yt .* cos(zeta);
	dyc_dx = dyc(1:round(length(dyc)/2)) ./ dx(1:round(length(dx)/2));
end
