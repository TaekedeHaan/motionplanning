function v = SCHEME_SDPInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 37);
  end
  v = vInitialized;
end
