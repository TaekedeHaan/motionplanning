function v = OP_LOG()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 70);
  end
  v = vInitialized;
end
