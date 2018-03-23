function v = IS_IMATRIX()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 149);
  end
  v = vInitialized;
end
