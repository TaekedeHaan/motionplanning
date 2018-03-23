function v = SCHEME_ControlledDAEInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 2);
  end
  v = vInitialized;
end
