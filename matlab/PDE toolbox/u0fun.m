function uinit = ufun(region,,state)

uinit = zeros(3,length(region.x));
uinit(1,:) = 80 + cos(2*pi*(region.x.));
