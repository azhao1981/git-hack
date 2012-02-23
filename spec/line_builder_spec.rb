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
end
