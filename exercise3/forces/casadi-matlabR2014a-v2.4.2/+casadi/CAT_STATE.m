function v = CAT_STATE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 169);
  end
  v = vInitialized;
end
