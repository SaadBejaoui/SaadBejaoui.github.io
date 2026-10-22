N_steps=500;
N=100;
L=5.0;
delta_max=0.2;
kB=1.0;
T0=0.1;
grid_size=ceil(N^(1/3));
[x,y,z]=ndgrid(linspace(0,L,grid_size+1)(1:end-1));
positions1=[x(:), y(:), z(:)];
positions1(randi(size(positions1,1)),:)=[];
N=size(positions1,1);
figure
scatter3(positions1(:,1),positions1(:,2),positions1(:,3),'r','filled');
axis([0 L 0 L 0 L]);
axis equal;
title('Configuration initiale');
print('visualisation_config_init.png', '-dpng');
figure
[r,g] = radial_distribution(positions1, L, 0.1, 5.0);
plot(r,g,'r');
xlabel('r');
ylabel('g(r)');
title('Distribution radiale initiale g(r)');
print('visualisation_dist_init.png', '-dpng');
M=5;
v1=zeros(1,M);
v2=zeros(1,M);
v3=zeros(1,M);
v4 = cell(1,M);
for k= 1:M
  positions=positions1;
  E=system_energy(positions,L);
  energies=zeros(1,N_steps);
  accepts=0;
  for step=1:N_steps
    printf("%d\n",step);
    T = T0%* exp(-3 * (step / N_steps));
    New_positions = positions;
    if rand() < 0.5
      i = randi(N);
      move = (rand(1,3)*2-1)*delta_max;
      New_positions(i,:) = mod(positions(i,:) + move, L);
    else
      i = randi(N);
      group = select_group(positions, i, 1.0);
      move = (rand(1,3)*2-1)*delta_max;
      New_positions(group,:) = mod(positions(group,:) + move, L);
    end
    E_new = system_energy(New_positions, L);
    delta_E = E_new - E;
    if (rand() < exp(-delta_E/(kB*T))) || (delta_E < 0)
      positions=New_positions;
      E=E_new;
      accepts += 1;
    end
    energies(step) = E;
  end
  r=[energies(N_steps),accepts]
  printf("l'energie finale de la relaxation num %d est %f",k,r(1))
  v1(k)=r(1);
  v3(k)=r(2);
  v4{k} = positions;
  endfor
s=sum(v1)/M;
for i=1:M
  v2(i)=(v1(i)-s)^2;
endfor
min=v1(1);
min_E=1;
min_A=1;
min_p=1;
for i=2:length(v1)
  if v1(i)<min
    min=v1(i);
    min_E=i;
    min_A=i;
    min_p=i;
  endif
  endfor
Ve=sum(v2)/M;
w=1.96*sqrt(Ve/M);
printf("IC à 95 : %d +-%f\n",s,w)
printf(" la configuration la plus stable correspond à l'energie %f\n",min)
positions=v4{min_p};
figure
scatter3(positions(:,1),positions(:,2),positions(:,3),'filled');
axis([0 L 0 L 0 L]);
axis equal;
title('Configuration optimale');
print('visualisation_config_optimale.png', '-dpng');
figure
[r,g] = radial_distribution(positions, L, 0.1, 5.0);
plot(r,g);
xlabel('r');
ylabel('g(r)');
title('Distribution radiale optimale g(r)');
printf("Taux d'acceptation : %.2f %%\n",100*v3(min_A)/N_steps);
print('visualisation_dist_optimale.png', '-dpng');

