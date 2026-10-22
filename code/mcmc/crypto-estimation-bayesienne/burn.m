function samples_clean=burn(burn_in,samples)
  samples_clean=samples(burn_in+1:end,:);
  fprintf("Burn-in : %d premiers échantillons ignorés.\n", burn_in);
endfunction
