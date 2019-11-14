class TrainSearchingWorker
  include Sidekiq::Worker

  def perform
    trainline_result = `python3 trainline_parser.py 04/07/1994 HC123456789 paris lyon '15/11/2019 10:00' '15/11/2019 18:00'`
    puts trainline_result
  end
end
