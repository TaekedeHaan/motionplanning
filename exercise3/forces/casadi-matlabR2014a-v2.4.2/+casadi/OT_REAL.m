function v = OT_REAL()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 49);
  end
  v = vInitialized;
end
