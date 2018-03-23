function v = FLAG()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 152);
  end
  v = vInitialized;
end
