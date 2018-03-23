function v = OP_MONITOR()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 134);
  end
  v = vInitialized;
end
