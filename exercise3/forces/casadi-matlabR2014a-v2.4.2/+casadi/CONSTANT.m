function v = CONSTANT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 155);
  end
  v = vInitialized;
end
