function v = SCHEME_IntegratorInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 13);
  end
  v = vInitialized;
end
