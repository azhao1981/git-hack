
require_relative "../core_ext/line_builder"


module GitHack
	class CommitLineBuilder < LineBuilder
		def initialize(data,index)
			super(data,index)
			@is_message = false
			@commit = { 'sha'=>nil, 'message' => '', 'parent' => [] }
			@is_next_commit = nil
		end
		def process_line
			@is_message
			line = @data[@index]		
			puts line
			line = line.chomp.strip
			if line == ""
				@is_message = !@is_message
			elsif @is_message
				@commit['message'] << line+"\n"
			else
				data = line.split
				@key = key = data.shift
				@value = data.join(" ")

				if @key == "\e[33mcommit"
				 	if @commit['sha']
						@is_next_commit = true
					else
						@commit['sha'] = @value
					end
				elsif @key == 'parent'
					@commit[@key] << @value
				else
					@commit[@key] = @value
				end
			end
			@object = @commit
		end
		def out?
			if @is_next_commit
				return true
			else
				@index += 1
				return false
			end
		end
	end
end


