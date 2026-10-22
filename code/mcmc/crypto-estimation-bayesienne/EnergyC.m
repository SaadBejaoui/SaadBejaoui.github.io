function E=energy(r, mu, sigma)
    n=length(r);
    E=n/2*log(2*pi*sigma^2)+sum((r-mu).^2)/(2*sigma^2);
end
