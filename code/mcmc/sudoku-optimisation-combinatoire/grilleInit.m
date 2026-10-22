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
## @deftypefn {} {@var{retval} =} grilleInit (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: msi <msi@DESKTOP-RKA4JPQ>
## Created: 2025-04-08

function grilleInit = grilleInit(X)
  n=size(X,1);
  for i=1:3:n
    for j=1:3:n
      bloc=X(i:i+2,j:j+2);
      vm=setdiff(1:9,bloc);
      [a,b]=find(bloc==0);
      for k=1:length(vm)
        bloc(a(k),b(k))=vm(k);
      end
      X(i:i+2,j:j+2)=bloc;
    end
  end
  grilleInit=X;
endfunction

