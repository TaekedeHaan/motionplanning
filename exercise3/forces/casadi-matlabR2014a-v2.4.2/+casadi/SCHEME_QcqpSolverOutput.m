function v = SCHEME_QcqpSolverOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 34);
  end
  v = vInitialized;
end
