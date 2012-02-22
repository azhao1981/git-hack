require_relative "../lib/git-hack"

include GitHack
include PathCommon
require "fileutils"

# 对目录进行刷新，如果有就删除之，新建
# 没有则新建
def refresh_dir(path)
	del_dir(path)
	Dir.mkdir(path)
end
def del_dir(path)
	FileUtils.rm_r(path,:force=>true) if File.directory?(path)
end
def add_for_commit
	File.open("#{project_dir}/spec/temp/test_for_commit","a") do |file|
		file.puts "test for commit"	
	end
end
