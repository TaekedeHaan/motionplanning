function v = OP_RESHAPE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 126);
  end
  v = vInitialized;
end
