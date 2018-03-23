function v = IS_GLOBAL()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 145);
  end
  v = vInitialized;
end
