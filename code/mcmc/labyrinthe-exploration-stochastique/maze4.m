clc; clear; close all;

% ---------------------
% PARAMÈTRES
% ---------------------
n = 21;  % taille du labyrinthe (impair recommandé)
start = [2, 2];
goal = [n-1, n-1];
iterations = 10000;

% ---------------------
% FONCTION : Génération du labyrinthe
% ---------------------
function maze = generate_maze(n)
  maze = ones(n, n);
  maze(2:2:end-1, 2:2:end-1) = 0;

  stack = [2, 2];
  visited = zeros(n);
  visited(2, 2) = 1;

  dirs = [0 -2; 0 2; -2 0; 2 0];

  while ~isempty(stack)
    current = stack(end, :);
    neighbors = [];

    for i = 1:4
      ni = current + dirs(i, :);
      if all(ni > 1 & ni < n) && visited(ni(1), ni(2)) == 0
        neighbors(end+1, :) = ni;
      end
    end

    if ~isempty(neighbors)
      next = neighbors(randi(size(neighbors, 1)), :);
      wall = (current + next) / 2;
      maze(wall(1), wall(2)) = 0;
      visited(next(1), next(2)) = 1;
      stack = [stack; next];
    else
      stack(end, :) = [];
    end
  end
end

maze = generate_maze(n);

% ---------------------
% FONCTION : Densité cible (plus proche de la sortie = mieux)
% ---------------------
function p = target_density(pos, goal)
  d = norm(pos - goal);
  p = exp(-0.5 * d);  % décroît avec la distance
end

% ---------------------
% METROPOLIS-HASTINGS
% ---------------------
pos = start;
samples = pos;
visit_count = zeros(n);

for i = 1:iterations
  candidates = [0 1; 0 -1; 1 0; -1 0];
  move = candidates(randi(4), :);
  new_pos = pos + move;

  if new_pos(1) > 0 && new_pos(1) <= n && ...
     new_pos(2) > 0 && new_pos(2) <= n && ...
     maze(new_pos(1), new_pos(2)) == 0

    p_new = target_density(new_pos, goal);
    p_old = target_density(pos, goal);
    alpha = min(1, p_new / p_old);

    if rand <= alpha
      pos = new_pos;
    end
  end

  samples(end+1, :) = pos;
  visit_count(pos(1), pos(2)) += 1;
end

% ---------------------
% AFFICHAGE DU LABYRINTHE ET TRAJECTOIRE
% ---------------------
figure;
imshow(1 - maze, 'InitialMagnification', 'fit'); hold on;
plot(samples(:,2), samples(:,1), 'r', 'LineWidth', 1);
plot(start(2), start(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(goal(2), goal(1), 'bo', 'MarkerSize', 10, 'LineWidth', 2);
title('Exploration par Metropolis-Hastings');
legend('Trajectoire', 'Départ', 'Sortie');

% ---------------------
% HEATMAP DES POSITIONS VISITÉES
% ---------------------
figure;
imagesc(visit_count);
colormap hot;
colorbar;
title('Fréquence des positions visitées');
xlabel('x'); ylabel('y');

% ---------------------
% ANALYSE 1 : Distribution des distances à la sortie
% ---------------------
distances = sqrt((samples(:,1) - goal(1)).^2 + (samples(:,2) - goal(2)).^2);
figure;
hist(distances, 30);
xlabel('Distance à la sortie');
ylabel('Fréquence');
title('Distribution des distances à la sortie');

% ---------------------

