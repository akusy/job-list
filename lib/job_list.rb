require 'pry'

class JobList
  attr_accessor :list_of_jobs, :result

  def initialize list_of_jobs = ''
    self.list_of_jobs = list_of_jobs
    self.result = []
  end

  def parse_jobs
    return "" if @list_of_jobs.empty?
    create_sequence @list_of_jobs.split(/\n/)
    @result.join
  end

  private

  def split_jobs jobs_array
    jobs_array.map{ |job| job.split(/\=>/).collect(&:strip).reject(&:empty?) }
  end

  def invalid_jobs? jobs
    raise DependencyError if jobs[0] == jobs[1]

    if @result.include?(jobs[0]) && @result.include?(jobs[1])
      raise CircularDependencyError if @result.index(jobs[0]) < @result.index(jobs[1])
      true
    end
  end

  class DependencyError < StandardError
    def initialize(msg = "Jobs can't depend on themselves.")
      super(msg)
    end
  end

  class CircularDependencyError < StandardError
    def initialize(msg = "Jobs can't have circular dependencies.")
      super(msg)
    end
  end
end
