function v = CAT_ALGEBRAIC()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 174);
  end
  v = vInitialized;
end
