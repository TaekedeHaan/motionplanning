function v = SCHEME_SDQPOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 40);
  end
  v = vInitialized;
end
