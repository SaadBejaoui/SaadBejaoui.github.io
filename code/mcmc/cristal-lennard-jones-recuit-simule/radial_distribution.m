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
## @deftypefn {} {@var{retval} =} radial-distribution (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: msi <msi@DESKTOP-RKA4JPQ>
## Created: 2025-04-29

function [r, g] = radial_distribution(positions, L, dr, r_max)
  N = size(positions,1);
  nbins = floor(r_max/dr);
  hist = zeros(1,nbins);
  for i = 1:N-1
    for j = i+1:N
      rij = positions(i,:) - positions(j,:);
      rij = rij - L*round(rij/L);
      r = norm(rij);
      if r < r_max
        bin = floor(r/dr) + 1;
        hist(bin) += 2;
      end
    end
  end
  r = dr*(0.5:nbins-0.5);
  rho = N/L^3;
  g = hist./(4*pi*r.^2*dr*rho*N);
end
