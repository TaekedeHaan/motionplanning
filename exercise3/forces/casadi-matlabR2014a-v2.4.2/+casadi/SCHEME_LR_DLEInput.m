function v = SCHEME_LR_DLEInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 19);
  end
  v = vInitialized;
end
