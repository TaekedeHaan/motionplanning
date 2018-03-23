function v = RADAU()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 154);
  end
  v = vInitialized;
end
