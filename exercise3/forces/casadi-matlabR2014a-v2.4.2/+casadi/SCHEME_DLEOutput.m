function v = SCHEME_DLEOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 5);
  end
  v = vInitialized;
end
