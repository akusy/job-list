require 'pry'

class JobList
  def initialize list_of_jobs = ''
    self.list_of_jobs = list_of_jobs
  end

  def parse_jobs
    return "" if @list_of_jobs.empty?
  end

  private
  attr_accessor :list_of_jobs, :final_sequence

end
