function v = OUTPUT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 160);
  end
  v = vInitialized;
end
