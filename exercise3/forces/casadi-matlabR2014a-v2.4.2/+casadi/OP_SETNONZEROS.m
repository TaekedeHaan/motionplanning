function v = OP_SETNONZEROS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 131);
  end
  v = vInitialized;
end
