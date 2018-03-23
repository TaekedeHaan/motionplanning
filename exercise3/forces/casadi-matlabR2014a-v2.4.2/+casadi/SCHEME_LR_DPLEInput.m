function v = SCHEME_LR_DPLEInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 21);
  end
  v = vInitialized;
end
