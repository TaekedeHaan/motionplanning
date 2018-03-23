function v = SCHEME_DAEInput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 9);
  end
  v = vInitialized;
end
