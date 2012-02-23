require "spec_helper"

describe CommitLineBuilder do
	before do
		g = Git.open(".")
		l = Git::Lib.new(g)
		opts = ["--pretty=raw"]
		@data = l.command_lines('log',opts)
		@linebuilder = CommitLineBuilder.new(@data,0)
		@linebuilder.parse
	end
	specify { @data.size.should be > 1 }
	specify { @linebuilder.object.should_not be nil }
	it "#object show" do
		ap @linebuilder.object
	end
end
