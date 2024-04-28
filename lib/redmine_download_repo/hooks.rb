module RedmineDownloadRepo
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_repositories_show_contextual, partial: 'download_repo/button'
  end
end