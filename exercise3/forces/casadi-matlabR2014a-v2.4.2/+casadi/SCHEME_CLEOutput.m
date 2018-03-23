function v = SCHEME_CLEOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 1);
  end
  v = vInitialized;
end
