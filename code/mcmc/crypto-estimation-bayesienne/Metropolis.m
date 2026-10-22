function [energies,samples]=Metropolis(mu,sigma,epsilon,T,r,E_seuil,T_min,N)
    samples=zeros(N,2);
    energies=zeros(N,1);
    for i=1:N
      mu_p=mu+randn*epsilon;
      sigma_p=abs(sigma+randn*epsilon);

      E_current=EnergyC(r,mu,sigma);
      E_proposed=EnergyC(r,mu_p,sigma_p);
      alpha=min(1,exp((E_current-E_proposed)/T));
      if rand<alpha
        mu=mu_p;
        sigma=sigma_p;
      end
      energies(i)=EnergyC(r,mu,sigma);
      samples(i,:)=[mu,sigma];

      if energies(i)<E_seuil && T>T_min
        T=T*0.9;
      end
    end
endfunction
