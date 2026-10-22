## Copyright (C) 2025 msi
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} calcul_energy (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: msi <msi@DESKTOP-RKA4JPQ>
## Created: 2025-04-14

function E = energy(grille)
  E=0;
  for i=1:9
    ligne=grille(i, :);
    E=E+(9 - length(unique(ligne)));
  end
  for j=1:9
    col=grille(:, j);
    E=E+(9 - length(unique(col)));
  end
  for bi=1:3:9
    for bj=1:3:9
      bloc=grille(bi:bi+2, bj:bj+2);
      E=E+(9 - length(unique(bloc)));
    end
  end
endfunction
