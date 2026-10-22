% ====== Initialisation des données ======
n=180;
mu_real=0.002;
sigma_real=0.02;
r=loadR(n,mu_real,sigma_real);
burn_in=5000;
P_last=95000;
% ====== Paramètres Metropolis-Hastings ======
N=50000;
T=0.05;
T_min = 0.001;
E_seuil = -447;
mu=0;
sigma=0.02;
epsilon=0.05;


% ====== Metropolis-Hastings ======
[energies,samples]=Metropolis(mu,sigma,epsilon,T,r,E_seuil,T_min,N);


% ========== Burn-in ==========
samples_clean=burn(burn_in,samples);


% ====== Prédiction du prix futur ======
r_next=normrnd(samples_clean(:,1),samples_clean(:,2));
P_next=P_last*(1+r_next);
[P_m,P_s]=MonteCarlo(P_next);

% ====== Analyse des résultats ======
fprintf("Prix moyen prévu : %.2f USD\n", P_m);
fprintf("Écart-type : %.2f USD\n", sqrt(P_s));
fprintf("IC 95%% : [%.2f ; %.2f] USD\n", P_m-(1.96*sqrt(P_s/length(P_next))), P_m+(1.96*sqrt(P_s/length(P_next))));

P_seuil=100000;
prob=mean(P_next>P_seuil);
fprintf("P(P > %.0f) = %.2f%%\n",P_seuil,100*prob);


% ====== Résumé statistique mu / sigma ======
[mu_m,mu_s]=MonteCarlo(samples_clean(:,1));
[sigma_m,sigma_s]=MonteCarlo(samples_clean(:,2));

% Composantes des intervalles de confiance
mu_IC=[mu_m-(1.96*sqrt(mu_s/length(samples_clean(:,1)))),mu_m+(1.96*sqrt(mu_s/length(samples_clean(:,1))))];
sigma_IC=[sigma_m-(1.96*sqrt(sigma_s/length(samples_clean(:,2)))),sigma_m+(1.96*sqrt(sigma_s/length(samples_clean(:,2))))];

fprintf("Estimation de mu : %.5f (IC 95%% : [%.5f ; %.5f])\n", mu_m,mu_IC(1),mu_IC(2));
fprintf("Estimation de sigma : %.5f (IC 95%% : [%.5f ; %.5f])\n", sigma_m,sigma_IC(1),sigma_IC(2));


% ====== Graphiques de convergence ======
figure;
subplot(3,1,1);
plot(1:N,energies,'b');
title("Évolution de l'énergie");
xlabel('Itération');
ylabel('Énergie');
grid on;

subplot(3,1,2);
plot(1:N, samples(:,1), 'r');
title('Évolution de \mu au cours des itérations');
xlabel('Itération');
ylabel('\mu');
grid on;

subplot(3,1,3);
plot(1:N, samples(:,2), 'g');
title('Évolution de \sigma au cours des itérations');
xlabel('Itération');
ylabel('\sigma');
grid on;


% ====== Histogrammes des paramètres ======
figure('Name', 'Distributions des paramètres après burn-in');

subplot(2,1,1);
[fm,cm]=hist(samples_clean(:,1),50);
bar(cm,fm/trapz(cm,fm),'FaceColor','r');
title('Distribution de \mu (après burn-in)');
xlabel('\mu');
ylabel('Densité');

subplot(2,1,2);
[fs,cs]=hist(samples_clean(:,2),50);
bar(cs,fs/trapz(cs,fs),'FaceColor', 'g');
title('Distribution de \sigma (après burn-in)');
xlabel('\sigma');
ylabel('Densité');


% ====== Histogramme du prix futur ======
figure('Name', 'Distribution du prix futur du Cryptomonnaie');
[fp,cp]=hist(P_next,50);
bar(cp,fp,'FaceColor',[0.2 0.4 0.6]);
title('Distribution du prix futur du Cryptomonnaie (J+1)');
xlabel('Prix (USD)');
ylabel('Fréquence');
grid on;
print('Histogramme_prix.png', '-dpng');

