require "git-hack/version"
require "git"
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require f }

module GitHack
	def self.current
		@current || get_dir('.')
	end
	def self.commit
		current.commit	
	end
	private
	# get_dir(path) 检查给定目录是否在git受控目录中
	# 本身是git目录返回 GitProject
	# 本身不是，但上层是返回GitProject，并设置dir
	# 本身不是，上层也不是则返回RawDir
	def self.get_dir(path)
		return GitRepo.new(path) if is_git(path)		
		return get_dir(File.join(path,"/../"))
	end
	def self.is_git(path)
		File.directory?(File.join(path,"/.git"))
	end
end

