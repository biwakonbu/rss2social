require 'yaml'

module Rss2Social
  class Source
    def initialize
      @sources = YAML.load_file('../config/sources.yml')
    end
  end
end
