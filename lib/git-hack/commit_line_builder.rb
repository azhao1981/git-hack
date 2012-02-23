
require_relative "../core_ext/line_builder"


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
			if line == ""
				@is_message = !@is_message
			elsif is_message
				@commit.message << line+"\n"
			else
				data = line.split
				key = data.shift
				value = data.join(" ")
				if key == 'commit'
					@commit['sha'] = value
				end
				if key == 'parent'
					@commit[key] << value
				else
				end
			end
		end
	end
end


