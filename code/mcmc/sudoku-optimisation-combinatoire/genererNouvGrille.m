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
## @deftypefn {} {@var{retval} =} genererNouvGrille (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: msi <msi@DESKTOP-RKA4JPQ>
## Created: 2025-04-08

function retval = genererNouvGrille(X,A1)
  n = size(X,1);
  v = [1 4 7];
  val1=v(randi(length(v)));
  val2=v(randi(length(v)));
  bloc1=X(val1:val1+2, val2:val2+2);
  bloc2=A1(val1:val1+2,val2:val2+2);
  [a,b]=find(bloc1 == 0);
  if length(a)>=2
    idx=randperm(length(a),2);
    tmp=bloc2(a(idx(1)),b(idx(1)));
    bloc2(a(idx(1)),b(idx(1)))=bloc2(a(idx(2)),b(idx(2)));
    bloc2(a(idx(2)),b(idx(2)))=tmp;
   end
   A1(val1:val1+2,val2:val2+2)=bloc2;
   retval=A1;
endfunction

