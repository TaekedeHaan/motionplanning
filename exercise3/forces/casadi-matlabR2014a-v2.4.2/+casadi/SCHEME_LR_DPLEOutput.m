function v = SCHEME_LR_DPLEOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 22);
  end
  v = vInitialized;
end
