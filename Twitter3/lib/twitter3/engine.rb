Gem.loaded_specs["twitter3"].runtime_dependencies.each do |d|
  begin
    require d.name
  rescue LoadError => le
    # Put exceptions here.
  end
end

module Twitter3
  class Engine < ::Rails::Engine
    isolate_namespace Twitter3
  end
end
