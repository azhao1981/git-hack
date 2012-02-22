require "git"
require 'logger'

require_relative "../core_ext/path"

module GitHack
	# GitRepo类拥有git的所有
	# 包括.git文件下所有的文件的功能的@git ,GitHack::Git类
	#     work，即工作目录及文件 GitHack::WorkingDirectory类
	#     remote，对应远程库信息 GitHack::Remote类
	#
	class GitRepo < Git::Path
		include PathCommon
		attr_accessor :git,:work,:remote
		def initialize(path)
			@workingdirectory = get_gitdir(path)	
		end
		def git
			@git ||= Git.open(@workingdirectory,:log => Logger.new(STDOUT)) 
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
			git.commit(msg)	
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
