function v = SCHEME_CLEInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 0);
  end
  v = vInitialized;
end
