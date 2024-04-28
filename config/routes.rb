Rails.application.routes.draw do
  get 'download_repo/download/:id', to: 'download_repo#download', as: 'download_repo'
end