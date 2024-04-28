class DownloadRepoController < ApplicationController
  unloadable

  before_action :find_repository

  def download
    latest_revision = get_latest_revision(@repository.root_url)
    zip_file_path = create_zip(@repository.url, @repository.root_url, latest_revision)
    send_file zip_file_path, type: 'application/zip', disposition: 'attachment', filename: File.basename(zip_file_path)
  ensure
    # Optionally, delete the zip file after sending it to the user to save disk space
    system "sleep 300 && rm -f #{Shellwords.escape(zip_file_path)} &"
  end

  private

  def find_repository
    @repository = Repository.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_latest_revision(repo_path)
    # Change to the repository's directory
    Dir.chdir(repo_path) do
      # Fetch the latest revision hash using git
      latest_revision = `git rev-parse HEAD`.strip
      return latest_revision
    end
  rescue
    # Handle potential errors, for example, if the repository path is invalid
    return 'head' # Fallback to 'head' if unable to fetch the latest revision
  end

  def create_zip(repo_url, repo_path, revision)
    # Assuming revision is the latest and is safe since it's fetched internally
    filename = "#{revision}.zip"
    temp_zip_path = Rails.root.join('tmp', filename).to_s

    safe_repo_path = Shellwords.escape(repo_path)
    system("git config --global --add safe.directory #{safe_repo_path}")

    Dir.chdir(safe_repo_path) do
      system("git archive --format zip --output #{Shellwords.escape(temp_zip_path)} #{revision}")
    end

    temp_zip_path
  end
end