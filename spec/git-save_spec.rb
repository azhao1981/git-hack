# Copyright @ weizhao 2012
# spec of git-save
# save mean save project in local 
# save in raw dir(haven git init) will do :
# 	git init
# 	git add .
# 	git commit -a -m "$msg"
# in git workspace will do
# 	git add .
# 	git commit -a -m "$msg"
require_relative  'spec_helper'

describe 'Run: git-save' do
	context "When given a not git directory" do
		it "Return current as a instance of GitProject " do
			#先测试一下git_repo文件
			#GitHack.current.should be_instance_of GitRepo
		end
		it "Return Commit as 1" do
			##GitHack.commit.should be 1	
		end
		it "Return dir as '/'" do
			#GitHack.dir.should be '/'
		end
	end
	context "When given a git workspace" do
	
	end
	
end
