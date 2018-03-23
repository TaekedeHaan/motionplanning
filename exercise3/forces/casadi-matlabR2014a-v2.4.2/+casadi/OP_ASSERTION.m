function v = OP_ASSERTION()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 133);
  end
  v = vInitialized;
end
