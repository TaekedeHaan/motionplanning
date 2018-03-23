function v = IS_MEMBER()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 146);
  end
  v = vInitialized;
end
