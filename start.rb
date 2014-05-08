require_relative 'lib/job_list'

# My checking file

p JobList.new("a => b \n d => \n b => c \n f => e").parse_jobs

begin
  JobList.new("a => \n b => c \n c => f \n d => a \n e => \n f => b").parse_jobs
rescue JobList::CircularDependencyError => e
  p e.inspect
end

begin
  JobList.new("a => \n b => c \n c => c \n d => a \n e => \n f => g").parse_jobs
rescue JobList::DependencyError => e
  p e.inspect
end
