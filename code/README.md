# Code source des projets

Code MATLAB des projets dont le rapport est publié dans [`../rapports/`](../rapports).
GitHub affiche ces fichiers directement, avec coloration syntaxique.

## `mcmc/` — Monte Carlo par chaînes de Markov (Metropolis–Hastings)

Quatre applications du même algorithme d'acceptation–rejet. Rapport :
[`Rapport_projet_probabilite.pdf`](../rapports/Rapport_projet_probabilite.pdf).

| Dossier | Application |
|---|---|
| `sudoku-optimisation-combinatoire/` | Optimisation combinatoire — résolution par minimisation d'une énergie de conflits, avec température décroissante (`alpha.m`) |
| `labyrinthe-exploration-stochastique/` | Exploration stochastique d'un labyrinthe |
| `cristal-lennard-jones-recuit-simule/` | Simulation thermodynamique 3D — potentiel de Lennard-Jones, recuit simulé, distribution radiale |
| `crypto-estimation-bayesienne/` | Estimation bayésienne de paramètres de rendement — 50 000 itérations, burn-in, intervalles à 95 % |

## `signal/` — Compression audio par codage en sous-bandes

`Code_Projet_TNS.m` — chaîne complète d'analyse-synthèse : filtres RIF à phase
linéaire, décimation, quantification multi-bandes, interpolation. Rapport :
[`Projet_TNS.pdf`](../rapports/Projet_TNS.pdf).

## Notebooks

Les deux projets Python sont dans `../rapports/` et se lisent mieux via nbviewer :
- [Calibration jointe SPX/VIX, modèle quintic OU](https://nbviewer.org/github/SaadBejaoui/SaadBejaoui.github.io/blob/main/rapports/Code_QuinticOU.ipynb)
- [Optimisation numérique](https://nbviewer.org/github/SaadBejaoui/SaadBejaoui.github.io/blob/main/rapports/CodeProjetOptimisation.ipynb)
