function [out] = posterior(beta,y,p_i)
sigma = std(p_i);
phi = 1/(sigma^2);
lik = sum(log(sqrt(phi/(2*pi))*exp((-phi/2)*(y-p_i).^2)));
pr = sum(log(exp(-(beta - 0).^2)));
out = pr+lik;
end



