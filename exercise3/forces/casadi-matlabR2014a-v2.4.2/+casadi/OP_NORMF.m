function v = OP_NORMF()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 138);
  end
  v = vInitialized;
end
