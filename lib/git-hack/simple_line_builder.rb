
require_relative "../core_ext/line_builder"

module GitHack
	class SimpleLineBuilder < LineBuilder
		attr_accessor :value
		def initialize(data,index)
			super(data,index)
		end
		def process_line
			line = @data[@index].chomp.split
			@object = line.shift
			@value = line.shift
		end
	end
end


