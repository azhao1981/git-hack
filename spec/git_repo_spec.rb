# 测试GitRepo类
#

require "spec_helper"


describe GitRepo do
	describe	"#get_gitdir " do
		context "When given a .git directory" do
			specify { GitRepo.new(dir_with_git).get_gitdir(dir_with_git).should == dir_with_git }
		end
		context "When given directory that parent have one .git" do
			before do
				@dir = dir_under_git
				refresh_dir(@dir)
			end
			specify { GitRepo.new(@dir).get_gitdir(@dir).should == project_dir  }
			after { del_dir(@dir) }
		end
		context "When given  no .git directory" do
			before do
				@dir = dir_no_git
				refresh_dir(@dir)
			end
			#specify {GitRepo.new(@dir).get_gitdir(@dir).should be nil}
			after { del_dir(@dir) }
		end
	end  # end of #get_gitdir test
	describe '#git_save' do
		context "When given a gitworking directory " do
			before do
				@dir = dir_under_git
				refresh_dir(@dir)
				Git.init(@dir) 
				@gitrepo = GitRepo.new(@dir)
				@gitrepo.get_gitdir(@dir)
				@msg = "test commit "
			end
			it "Should be success " do
				add_for_commit("#{@dir}/test")
				@gitrepo.git_save(@msg).should be_success
				# commit without change.
				@gitrepo.git_save(@msg).should be_success
			end
			after { del_dir(@dir) }
		end
		context "When given a nogitworking directory" do
			before do
				@dir = dir_no_git
				refresh_dir(@dir)
				@gitrepo = GitRepo.new(@dir)
				@gitrepo.get_gitdir(@dir)
			end
			it "Should execute false  " do
				@gitrepo.git_save("false test commit").should_not be_success
				#expect {  not raise a error any more
		 		#	@gitrepo.git_save(@dir)
				#}.to raise_error(SystemExit)  
			end
			after { del_dir(@dir) }
		end
	end #  end of #git_save est
	describe "#goto " do
		before (:each) do
			@dir = dir_no_git
			refresh_dir(@dir)
			Git.init(@dir) 
			@gitrepo = GitRepo.new(@dir)
			@gitrepo.get_gitdir(@dir)
			add_for_commit("#{@dir}/file.txt")
			@gitrepo.git_save("init")
			add_for_commit("#{@dir}/newfile.txt")
			@gitrepo.git_save("commit second")
		end
		context "When given 1" do
			it "Should be success and no file newfile.txt" do
				@gitrepo.goto(1).should be_success
				File.exist?("#{@dir}/newfile.txt").should be false
			end
			it "Should still get 2 commit" do
				@gitrepo.commits.size.should == 2
				@gitrepo.goto(1).should be_success
				@gitrepo.commits.size.should == 2
				@gitrepo.goto(0).should be_success
				File.exist?("#{@dir}/newfile.txt").should be true
			end
		end
		context "When given 2," do
			it "Should goto the last commit" do
				@gitrepo.goto(1).should be_success
				File.exist?("#{@dir}/newfile.txt").should be false
				@g = GitRepo.new(@dir)
				@g.get_gitdir(@dir)
				@gitrepo.goto(0).should be_success
				File.exist?("#{@dir}/newfile.txt").should be true
			end
		end
		after { del_dir(@dir) }
	end     #--end of #checkout
	describe "#redo" do
		before (:each) do
			@dir = dir_no_git
			refresh_dir(@dir)
			Git.init(@dir) 
			@gitrepo = GitRepo.new(@dir)
			@gitrepo.get_gitdir(@dir)
			add_for_commit("#{@dir}/file.txt")
			@gitrepo.git_save("init")
			add_for_commit("#{@dir}/newfile.txt")
			@gitrepo.git_save("commit second")
		end
		context "When no undo" do
			it "Should be failed" do
				@gitrepo.redo.should_not be_success
			end
		end
		context "When undo first" do
			it "Should be success" do
				File.exist?("#{@dir}/newfile.txt").should be true
				@gitrepo.undo
				File.exist?("#{@dir}/newfile.txt").should be false
				@g = GitRepo.new(@dir)
				@g.get_gitdir(@dir)
				@g.redo.should be_success
				File.exist?("#{@dir}/newfile.txt").should be true
			end
		end
		after{ del_dir(@dir) }
	end
		
end
