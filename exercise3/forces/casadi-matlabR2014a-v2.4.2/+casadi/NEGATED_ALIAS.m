function v = NEGATED_ALIAS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 166);
  end
  v = vInitialized;
end
