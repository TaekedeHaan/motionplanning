function v = SCHEME_SOCPStruct()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 43);
  end
  v = vInitialized;
end
