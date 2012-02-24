require "git"
require 'logger'
require 'colorize'  
require "ap"

require_relative "../core_ext/path"

module GitHack
	# GitRepo类拥有git的所有
	# 包括.git文件下所有的文件的功能的@git ,GitHack::Git类
	#     work，即工作目录及文件 GitHack::WorkingDirectory类
	#     remote，对应远程库信息 GitHack::Remote类
	#
	class GitRepo < Git::Path
		include PathCommon
		attr_accessor :git,:commits,:work,:remote,:current_commit
		def initialize(path)
			@workingdirectory = get_gitdir(path)	
			@commits = []
		end
		def git
			@git ||= Git.open(@workingdirectory ,:log => Logger.new(STDOUT)) 
		end
		def commits
			return @commits if !@commits.empty?
			l = Git::Lib.new(git)
			opts = ["--pretty=raw"]
			@data = l.command_lines_patch('log',opts)
			return @commits = CommitLineBuilder.new(@data,0).find_all
		end
		# 得到本身或是上层目录中.git文件的路经
		def get_gitdir(path)
			git_path = absolute_path(path)
			return nil if git_path == "/"
			return git_path if is_gitdir?(git_path) 
			return get_gitdir(join(git_path,"/../"))
		end
		def is_gitdir?(path)
			File.directory?(join(path,".git")) ? true : false
		end
		# 把工作目录的文件添加到git仓库并提交 
		def git_save(msg,options={})
			ready_to_execute
			return self if not_git_directory?
			add_workingdirectory
			commit(msg)
			execute_success
			self
		end
		def ready_to_execute
			@is_success = false
		end
		def execute_success
			@is_success = true
		end
		def success?
			@is_success
		end
		def add_workingdirectory
			git.add(@workingdirectory)	
		end
		def commit(msg)
			msg ||= auto_commit_msg 
			begin
				git.commit(msg,:add_all=>true)	
			rescue Git::GitExecuteError => e
				puts e.to_s.colorize(:green)
			end
		end
		def auto_commit_msg
			"auto commit" # TODO: 需要完成
		end
		# undo 回到上一次提交
		def undo
			git_goto(1)
		end
		# redo 到当前提交的下一个提交
		def redo
			ready_to_execute
			return self if not_git_directory?
			next_commit = get_next_commit
			return self if !next_commit
			git.reset_hard(next_commit)
			execute_success
			self
		end
		def git_goto(number,options={})
			number = number.to_i
			goto(number,options)
			
		end
		# 回到前第number个保存
		#
		def goto(number,options={})
			ready_to_execute
			return self if not_git_directory?
			git.reset_hard(commits[number].commit['sha'])
			execute_success
			self
		end
		def init(dir)
			@git = Git.init(dir)
			@workingdirectory = dir
		end
		def not_git_directory?
			if @workingdirectory == nil
				puts "Not a git directory ,run `git init` first"
				return true
			end
			return false
		end
		def get_next_commit 
			file = File.open("#{@workingdirectory}/.git/logs/HEAD")
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
			data = data_from_file("#{@workingdirectory}/.git/HEAD")
			commit_file_data = SimpleLineBuilder.new(data,0).parse
			commit_file = commit_file_data.value
			@current_commit = data_from_file("#{@workingdirectory}/.git/#{commit_file}")
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
