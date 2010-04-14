module LogsHelper
  def present_log(log)
    LogPresenter.new(:log => log)
  end
end