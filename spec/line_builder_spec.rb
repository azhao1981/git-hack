require "spec_helper"

describe LineBuilder do
	before do
		g = Git.open(".")
		l = Git::Lib.new(g)
		@lib = l
		opts = ["--pretty=raw"]
		@data = l.command_lines_patch('log',opts)
		@linebuilder = LineBuilder.new(@data,0)
		@linebuilder.parse
	end
	specify { @data.size.should be > 1 }
	specify { @linebuilder.object.should_not be nil }
	specify { @linebuilder.all_objects.size.should be > 0 }
	specify { @linebuilder.is_over?.should_not be true }
	specify { @linebuilder.get_next.should_not be nil }
	specify { @linebuilder.rest.size.should be > 0 }
	specify { @linebuilder.find_all.size.should be > 0 }
	specify { @linebuilder.data.should be @linebuilder.get_next.data }
	# 用于查看内部数据的查看spec
	it "Show Some data" do
		puts @linebuilder.index
		puts @data.size
	end
	context "When is come to the last" do
		before do
			@last = LineBuilder.new(@data,@data.size-1)
			@last.parse
		end
		specify { @last.should be_is_over }	

		specify { @last.get_next.should be  nil }	
		specify { @last.rest.size.should be  0 }
		specify { @last.find_all.size.should be  1 }
	end
	context "When is over" do
		before do
			@over = LineBuilder.new(@data,@data.size)
			@over.parse
		end
		specify { @over.should be_is_over }	

		specify { @over.get_next.should be  nil }	
		specify { @over.rest.size.should be  0 }
		specify { @over.find_all.size.should be  0 }
		it "Show Find_all" do
		#	puts "lash find_all"
		#	ap @over.find_all
		end
	end
end
