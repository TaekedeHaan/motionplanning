function v = SCHEME_LpSolverInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 17);
  end
  v = vInitialized;
end
