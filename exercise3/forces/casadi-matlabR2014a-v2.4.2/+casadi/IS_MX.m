function v = IS_MX()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 151);
  end
  v = vInitialized;
end
