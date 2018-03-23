function v = SCHEME_LR_DLEOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 20);
  end
  v = vInitialized;
end
