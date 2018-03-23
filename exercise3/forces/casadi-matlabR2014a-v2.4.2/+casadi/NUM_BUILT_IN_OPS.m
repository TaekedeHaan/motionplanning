function v = NUM_BUILT_IN_OPS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 144);
  end
  v = vInitialized;
end
