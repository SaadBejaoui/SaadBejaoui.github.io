function [m,s]=MonteCarlo(x)
  N=length(x);
  m=sum(x)/N;
  s=sum((x-m).^2)/N;
endfunction
