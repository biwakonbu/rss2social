require 'rss'
require 'yaml'
require 'sqlite3'
require 'singleton'

module RSS2Social
  class UpdateManager
    def initialize
      @src = Source.instance
      @dest = Destination.instance
      @model = RSSEntryModel.new
      @controller = RSSController.new(@src, @model)
    end
    
    def run
      @controller.update
    end
  end

  class RSSController
    def initialize(src, model)
      @src = src
      @model = model
    end

    def update
      entries = RSS::Parser.parse(@src.list[0]['url'])
      entries.items.each do |item|
        @model.insert(item.title, item.link) unless @model.select(item.title, item.link)
      end
    end
  end

  class RSSEntryModel
    def initialize
      @db = SQLite3::Database.new(File.expand_path('../../db', __FILE__) + '/rss.db')
    end

    def insert(title, url)
      @db.execute("INSERT INTO rss_entries(title, url) VALUES (?, ?)", [title, url])
    end

    def select(title, url)
      @db.execute("SELECT title, url FROM rss_entries WHERE title=? AND url=?", [title, url])
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
