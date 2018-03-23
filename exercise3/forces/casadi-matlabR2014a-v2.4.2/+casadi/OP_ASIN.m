function v = OP_ASIN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 79);
  end
  v = vInitialized;
end
