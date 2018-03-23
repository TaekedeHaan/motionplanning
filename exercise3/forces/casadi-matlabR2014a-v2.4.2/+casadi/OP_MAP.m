function v = OP_MAP()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 113);
  end
  v = vInitialized;
end
