# frozen_string_literal: true
namespace :cloudfactory do
  desc 'File Copy tasks'
  task :file_copy do
    on roles(:app, :worker) do
      within release_path do
        execute './configure'
      end
    end
  end
end
before 'deploy:updated', 'cloudfactory:file_copy'
