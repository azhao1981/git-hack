
require_relative "../git-hack"


module GitHack
	class CommitLineBuilder < LineBuilder
		def initialize(data,index)
			super(data,index)
			@is_message = false
			@commit = { 'masseg' => '', parent => []}
		end
		def process_line
			@is_message
			line = @data[@index]		
			line = line.chomp
			if line = ""
				@is_message = !@is_message
			elsif is_message
				@commit.message << line+"\n"
			else
				data = line.split
				key = data.shift
				value = data.join(" ")

			end
		end
	end
end


