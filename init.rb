Redmine::Plugin.register :redmine_download_repo do
  name 'Redmine Download Repo plugin'
  author 'Ben Shefte / ChatGPT 4'
  description 'This plugin adds a download button to repositories'
  version '0.0.1'
  url 'http://neuwon.com'
  author_url 'http://neuwon.com'

  requires_redmine version_or_higher: '5.0.3'
end

# Make sure this path is correct
require File.dirname(__FILE__) + '/lib/redmine_download_repo/hooks'