function [x, y] = NACA(num, c, N)
	% Only defined for an even number of panels
	t = mod(num, 100) / 100;
	l = mod(floor(num / 100), 10) / 10;
	m = floor(num / 1000) / 100;

	theta = linspace(0, pi, N/2);
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

	xu = x - yt .* sin(zeta);
	xl = x + yt .* sin(zeta);
	yu = yc + yt .* cos(zeta);
	yl = yc - yt .* cos(zeta);

	% Proceeds from the trailing edge around the bottom of the airfoil and back around the top
	x = [xl xu(end-1:-1:1)];
	y = [yl yu(end-1:-1:1)];
end
