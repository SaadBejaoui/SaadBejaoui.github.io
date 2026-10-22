function r=loadR(n,mu_real,sigma_real)
  % Vérifier si le vecteur de rendement a déjà été sauvegardé
  if exist('r_saved.mat','file')
    load('r_saved.mat','r');  % Charger le vecteur de rendement sauvegardé
  else
    r=mu_real+sigma_real*randn(n,1);
    save('r_saved.mat','r');  % Sauvegarder le vecteur de rendement pour les prochaines exécutions
  end
endfunction
