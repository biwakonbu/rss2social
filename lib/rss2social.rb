require 'rss'
require 'yaml'
require 'singleton'

module RSS2Social
  class UpdateManager
    def initialize
      @src = Source.instance
      @dest = Destination.instance
      @model = RSSEntry.new
      @controller = RSSController.new(@src)
    end

    def run
      @controller.update
    end
  end

  class RSSController
    def initialize(src)
      @src = src
    end

    def update
      entries = RSS::Parser.parse(@src.list[0]['url'])
      puts entries
    end
  end

  class RSSEntry
    def initialize
    end
  end

  class Source
    include Singleton
    attr_reader :list

    def initialize
      @list = YAML.load_file(File.expand_path('../../config', __FILE__) + '/sources.yml')
    end
  end

  class Destination
    include Singleton
    attr_reader :list

    def initialize
      @list = YAML.load_file(File.expand_path('../../config', __FILE__) + '/destinations.yml')
    end
  end
end
