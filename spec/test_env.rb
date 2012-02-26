# 为测试准备环境用的一些方法
module TestENV
	def dir_with_git
		project_dir
	end
	def dir_under_git
		join(project_dir,"tmp_git_hack_test")
	end
	def dir_no_git
		"#{ENV["HOME"]}/tmp_git_hack_test" 
	end
end

	

