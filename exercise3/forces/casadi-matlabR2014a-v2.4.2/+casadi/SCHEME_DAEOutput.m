function v = SCHEME_DAEOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 10);
  end
  v = vInitialized;
end
