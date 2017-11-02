require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Daeha
  class Application < Rails::Application
    config.after_initialize do
      puts "대나무숲 크롤링을 시작합니다 :)"
      # 주석을 풀어주세요.
      FbJob.perform_later "initial", "start"
    end
  end
end
