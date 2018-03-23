function v = OP_INNER_PROD()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 119);
  end
  v = vInitialized;
end
