require "spec_helper"

describe CommitFacade do
	before do
		@dir = dir_under_git
		refresh_dir(@dir)
		Git.init(@dir) 
		@gitrepo = GitRepo.new(@dir)
		@gitrepo.get_gitdir(@dir)
		@msg = "test commit "
		add_for_commit("#{@dir}/test")
		@gitrepo.git_save(@msg)
		add_for_commit("#{@dir}/test2")
		@gitrepo.git_save(@msg)
		@cf = CommitFacade.new(@dir)
	end
	describe "# get_log_commits " do
		context "When given dir " do
			it "Should return commits frome log. " do
				@cf.get_log_commits.length.should be 2
			end
			it "Show data" do
				#ap @cf.get_log_commits
				#ap @cf.get_log_commits[0]
			end
			
		end
		
	end
	after { del_dir(@dir) }
end
