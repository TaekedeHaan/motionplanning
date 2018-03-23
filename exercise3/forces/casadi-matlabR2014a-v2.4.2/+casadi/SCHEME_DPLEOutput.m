function v = SCHEME_DPLEOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 7);
  end
  v = vInitialized;
end
