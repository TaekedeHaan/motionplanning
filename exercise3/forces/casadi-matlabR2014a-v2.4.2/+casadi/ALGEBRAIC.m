function v = ALGEBRAIC()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 162);
  end
  v = vInitialized;
end
