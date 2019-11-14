class TrainSearchingWorker
  include Sidekiq::Worker

  def perform
    hello_python = `python3 test.py`
    puts hello_python
  end
end
