function v = OT_BOOLEAN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 47);
  end
  v = vInitialized;
end
