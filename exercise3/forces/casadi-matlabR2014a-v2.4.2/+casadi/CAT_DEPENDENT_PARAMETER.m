function v = CAT_DEPENDENT_PARAMETER()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 172);
  end
  v = vInitialized;
end
