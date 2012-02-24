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
		attr_accessor :git,:commits,:work,:remote
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
		# undo 如果有修改,保存,然后回到上一次提交
		def undo
			git_save if working_directory_change?
			checkout(1)    # check_out 0.当前1.上一个.2.上上个....
		end
		# check out 出前第number个保存
		def checkout(number,options={})
			ready_to_execute
			return self if not_git_directory?
			puts "commits:".colorize(:red)
			ap commits
			git.reset(commits[1].commit['sha'])
			execute_success
			self
		end
		def init(dir)
			@git = Git.init(dir)
			@workingdirectory = dir
		end
		def not_git_directory?
			if @workingdirectory == nil
				puts "Init first,run git init"
				return true
			end
			return false
		end
	end
end
