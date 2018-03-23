function v = OT_STRINGVECTOR()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 55);
  end
  v = vInitialized;
end
