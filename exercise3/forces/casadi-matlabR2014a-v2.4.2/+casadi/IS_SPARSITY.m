function v = IS_SPARSITY()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 147);
  end
  v = vInitialized;
end
