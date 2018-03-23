function v = SCHEME_DPLEInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 6);
  end
  v = vInitialized;
end
