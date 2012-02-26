# CommitLineBuilder类用于得到库内的提交信息
# 现阶段从git log命令得到主数据
require_relative "../core_ext/line_builder"

# git log 数据可能被加色,本补丁删除加色信息
class String
	def uncolorize
		self.gsub(/\e\[(\d+)*m/,"")  # 以除 \e[30e]	 颜色标记
	end
end
class Hash
	def to_class(new_class)
		return new_class.new(self)
	end
end

module GitHack
	class CommitLineBuilder < LineBuilder
		attr_accessor :commit
		def initialize(data,index)
			super(data,index)
			@is_message = false
			@commit = { 'sha'=>nil, 'message' => '', 'parent' => [] }
			@is_next_commit = false
		end
		# 重写#process_line
		def process_line
			line = @data[@index].chomp.uncolorize
			if line == ""          # msg信息以上下两个"" 分隔
				@is_message = !@is_message
			elsif @is_message
				@commit['message'] << line+"\n"
			else
				line_to_commit(line)
			end
			@object = @commit.to_class(Commit)
		end
		# 将每行的数据信息转换成Commit的信息
		def line_to_commit(line)
			data = line.split
			key = data.shift
			value = data.join(" ")

			if key == "commit"
			 	if @commit['sha']  		# key第二次是commit时 设置是否下条信息的标志,见 #out?
					@is_next_commit = true  
				else
					@commit['sha'] = value
				end
			elsif key == 'parent'
				@commit[key] << value
			else
				@commit[key] = value
			end
		end
		def out?
			# 如果已经到下一条commit,则为结束标志,并指针并不再移动
			@index += 1 unless @is_next_commit
			return @is_next_commit 
		end
	end
end


