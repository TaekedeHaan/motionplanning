function v = OT_BOOLVECTOR()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 53);
  end
  v = vInitialized;
end
