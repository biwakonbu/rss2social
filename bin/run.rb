$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'rss2social'

rss = RSS2Social::UpdateManager.new
rss.run
