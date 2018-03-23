function v = CAT_DEPENDENT_CONSTANT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 170);
  end
  v = vInitialized;
end
