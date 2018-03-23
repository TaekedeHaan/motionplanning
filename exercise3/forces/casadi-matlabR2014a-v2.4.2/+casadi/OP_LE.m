function v = OP_LE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 83);
  end
  v = vInitialized;
end
