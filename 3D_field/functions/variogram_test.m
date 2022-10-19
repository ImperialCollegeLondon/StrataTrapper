n = 1000;
sigma = 5;
wn = normrnd(0,sigma,n,1);
figure(1); plot(wn)
figure(2); plot(xcov(wn))
