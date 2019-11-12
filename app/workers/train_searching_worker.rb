class TrainSearchingWorker
  include Sidekiq::Worker

  def perform
    puts 'Hello World!'
  end
end
