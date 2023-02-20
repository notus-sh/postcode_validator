# frozen_string_literal: true

def load_fixtures(name)
  source = "spec/fixtures/#{name}.yml"

  begin
    YAML.load_file(source, aliases: true)
  rescue ArgumentError
    YAML.load_file(source)
  end
end
