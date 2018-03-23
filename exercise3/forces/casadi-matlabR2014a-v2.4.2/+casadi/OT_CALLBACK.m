function v = OT_CALLBACK()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 59);
  end
  v = vInitialized;
end
