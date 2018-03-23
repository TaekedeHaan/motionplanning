function v = SCHEME_NLPOutput()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 24);
  end
  v = vInitialized;
end
