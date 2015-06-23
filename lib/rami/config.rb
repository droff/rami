module RAMI
  class Config
    def self.load(config_file)
      YAML.load_file(config_file)
    end
  end
end