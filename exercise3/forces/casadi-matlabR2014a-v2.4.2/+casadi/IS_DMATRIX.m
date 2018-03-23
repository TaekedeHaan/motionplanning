function v = IS_DMATRIX()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 148);
  end
  v = vInitialized;
end
