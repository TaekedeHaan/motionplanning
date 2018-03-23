function v = OT_INTEGERVECTOR()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 51);
  end
  v = vInitialized;
end
