# CommitFacade 类提供一个对外的git commit的接口
#
require_relative "commit_line_builder"
require_relative "simple_line_builder"

module GitHack
	class CommitFacade
		def initialize(dir)
			@dir = dir	
			@commits = []
		end
		# 从log中取得当前commit之前的Commits
		#
		def get_log_commits
			git = Git.open(@dir ,:log => Logger.new(STDOUT)) 
			l = Git::Lib.new(git)
			opts = ["--pretty=raw"]
			data = l.command_lines_patch('log',opts)
			ap data
			return @commits = CommitLineBuilder.new(data,0).all_objects
		end
		def get_next_commit 
			file = File.open("#{@dir}/.git/logs/HEAD")
			data = []
			file.each { |line|
				data << line
			}
			commit_data = SimpleLineBuilder.new(data,0).find_all
			commit = commit_data.find do |c| 
				c.object == current_commit 
			end
			commit_sha = commit ?  commit.value : nil
		end
		def current_commit
			@current_commit if @current_commit
			data = data_from_file("#{@dir}/.git/HEAD")
			commit_file_data = SimpleLineBuilder.new(data,0).parse
			commit_file = commit_file_data.value
			@current_commit = data_from_file("#{@dir}/.git/#{commit_file}")
			@current_commit = @current_commit[0].chomp
		end
		def data_from_file(path)
			file = File.open(path)
			data = []
			file.each { |line|
				data << line
			}
			data 
		end
	end
end
