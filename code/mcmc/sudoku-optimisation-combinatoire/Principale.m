X=[0 0 0 0 1 0 0 3 0;
   6 8 2 0 0 3 4 9 1;
   0 4 3 9 0 8 0 7 0;
   2 1 5 3 8 6 0 4 9;
   3 0 4 5 7 2 0 0 0;
   7 6 0 1 0 0 2 5 3;
   4 2 0 8 9 1 3 6 0;
   8 3 1 4 0 0 9 2 0;
   9 0 0 2 0 7 1 0 4];
T=0.3;
N=800;
M=7;
v1=zeros(1,M);
v2=zeros(1,M);
for l=1:M;
  A1=grilleInit (X);
  k=0;
  for i=1:N
    A2=genererNouvGrille (X,A1);
    E1=energy(A1);
    E2=energy(A2);
    p=alpha(A1,A2,T);
    if (E2==0)
      A1=A2;
      disp(A1)
      printf("le nombre d'opérations dans l'iteration numéro %d : %d\n",l,k)
      v1(l)=k;
      break
    endif
    k=k+1;
    if rand<p
      A1=A2;
    endif
    if E1<10
      T=0.1;
    endif
   endfor
endfor
s=sum(v1)/M;
for i=1:M
  v2(i)=(v1(i)-s)^2;
endfor
Ve=sum(v2)/M;
w=1.96*sqrt(Ve/M);
printf("IC à 95 : %d +-%f\n",s,w)

