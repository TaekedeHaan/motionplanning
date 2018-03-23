function v = NO_ALIAS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 164);
  end
  v = vInitialized;
end
