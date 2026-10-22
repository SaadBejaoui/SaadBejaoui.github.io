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
## @deftypefn {} {@var{retval} =} system_energy (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: msi <msi@DESKTOP-RKA4JPQ>
## Created: 2025-04-29

function E = system_energy(positions, L)
  N = size(positions,1);
  E = 0;
  for i = 1:N-1
    for j = i+1:N
      rij = positions(i,:) - positions(j,:);
      rij = rij - L*round(rij/L);
      r2 = sum(rij.^2);
      if r2 < (3.0^2)
        E += lennard_jones(r2);
      end
    end
  end
end
