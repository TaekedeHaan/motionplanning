function v = SCHEME_StabilizedQpSolverInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 44);
  end
  v = vInitialized;
end
