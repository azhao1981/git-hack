require "git"
require 'logger'

module GitHack
	# GitRepo类拥有git的所有
	# 包括.git文件下所有的文件的功能的@git ,GitHack::Git类
	#     work，即工作目录及文件 GitHack::WorkingDirectory类
	#     remote，对应远程库信息 GitHack::Remote类
	#
	class GitRepo < Git::Path
		attr_accessor :git,:work,:remote
		def initialize(path)
			@workingdirectory = get_gitdir(path)	
			exit_if_not_git_directory
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
			add_workingdirectory
			commit(msg)
		end
		def add_workingdirectory
			git.add(@workingdirectory)	
		end
		def commit(msg)
			git.commit(msg)	
		end
		def exit_if_not_git_directory
			if @workingdirectory == nil
				puts "Init first,run git init"
				exit
			end
		end
	end
	class RawDir < Git::Path
		
	end
end
