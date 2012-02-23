# 测试GitRepo类
#

require "spec_helper"


describe GitRepo do
	# test data
	let(:dir_with_git) { project_dir }
	let(:dir_under_git) { join(project_dir,"tmp_git_hack_test") }
	let(:dir_no_git) { "#{ENV["HOME"]}/tmp_git_hack_test" }

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
	describe "#checkout " do
		before (:each) do
			@dir = dir_no_git
			refresh_dir(@dir)
			Git.init(@dir) 
			@gitrepo = GitRepo.new(@dir)
			@gitrepo.get_gitdir(@dir)
		end
		context "When given 1,checkout to previous commitish" do
			it "Should be success and no file newfile.txt" do
				puts "Now begin test checkou :#{@dir}"
				add_for_commit("#{@dir}/file.txt")
				@gitrepo.git_save("init")
				add_for_commit("#{@dir}/newfile.txt")
				@gitrepo.git_save("commit second")
				#@gitrepo.checkout(1).should be_success
				#File.exist?("#{@dir}/newfile.txt").should be false
			end
		end
		after { del_dir(@dir) }
	end     #--end of #checkout
end
