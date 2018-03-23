function v = SCHEME_NlpSolverOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 32);
  end
  v = vInitialized;
end
