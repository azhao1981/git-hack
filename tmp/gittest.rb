# test Git
#
require "git"
require "ap"

g = Git.open(".")

l = Git::Lib.new(g)


class Builder
	
end
class LineParser
	
end





#l.full_log_commits
def process_commit_data(data, sha = nil, indent = 4)
	in_message = false
	#hsh = nil
	#hsh_array = []
	if sha
		hsh = {'sha' => sha, 'message' => '', 'parent' => []}
	else
		hsh_array = []        
	end
	data.each do |line|
		line = line.chomp
		if line == ''
			in_message = !in_message
		elsif in_message
			hsh['message'] << line[indent..-1] << "\n"
		else
			data = line.split
			key = data.shift
			value = data.join(' ')
			if key == 'commit'
				sha = value
				hsh_array << hsh if hsh
				hsh = {'sha' => sha, 'message' => '', 'parent' => []}
			end
			if key == 'parent'
				hsh[key] << value
			else
				hsh[key] = value
			end
		end
	end

	if hsh_array
		hsh_array << hsh if hsh
		hsh_array
	else
		hsh
	end
end
data = l.command_lines('log',["--pretty=raw"])
puts "data:"
ap data
log =  process_commit_data(data,"commit")
