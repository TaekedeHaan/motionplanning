function v = OP_PRINTME()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 142);
  end
  v = vInitialized;
end
