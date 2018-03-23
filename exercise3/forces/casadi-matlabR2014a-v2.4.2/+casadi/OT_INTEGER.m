function v = OT_INTEGER()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 48);
  end
  v = vInitialized;
end
