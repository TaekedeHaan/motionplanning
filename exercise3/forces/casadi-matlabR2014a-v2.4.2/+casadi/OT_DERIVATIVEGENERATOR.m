function v = OT_DERIVATIVEGENERATOR()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 57);
  end
  v = vInitialized;
end
