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

  def create_sequence jobs_array
    split_jobs(jobs_array).each do |jobs|
      if jobs.count == 1
        @result << jobs.first unless @result.include?(jobs.first)
        next
      end  
      next if invalid_jobs?(jobs)
      find_depedency_and_add_jobs jobs
    end
  end

  def invalid_jobs? jobs
    raise DependencyError if jobs[0] == jobs[1]

    if @result.include?(jobs[0]) && @result.include?(jobs[1])
      raise CircularDependencyError if @result.index(jobs[0]) < @result.index(jobs[1])
      true
    end
  end

  def find_depedency_and_add_jobs jobs
    if index = @result.index(jobs[0])
      @result.insert(index, jobs[1])
    elsif index = @result.index(jobs[1])
      @result.insert(index+1, jobs[0])
    else
      @result << jobs[1]
      @result << jobs[0]
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
