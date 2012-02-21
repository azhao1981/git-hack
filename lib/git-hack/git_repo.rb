require "git"

module GitHack
	# GitRepo类拥有git的所有
	# 包括.git文件下所有的文件的功能的@git ,GitHack::Git类
	#     work，即工作目录及文件 GitHack::WorkingDirectory类
	#     remote，对应远程库信息 GitHack::Remote类
	#
	class GitRepo < Git::Path
		attr_accessor :git,:work,:remote
		def get_gitdir(path)
			git_path = absolute_path(path)
			return false if git_path == "/"
			return git_path if File.directory?(join(git_path,".git"))
			return get_gitdir(absolute_path(join(git_path,"/../")))
		end
	end
	class RawDir < Git::Path
		
	end
end
