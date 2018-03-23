function v = OP_HORZREPSUM()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 140);
  end
  v = vInitialized;
end
