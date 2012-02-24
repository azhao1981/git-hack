#
# 把文本转化成对象的Build模式
#
#
class LineBuilder
	attr_accessor :data,:index,:object
	def initialize(data,index=0)
		@data = data
		@index = index
		@object = nil
		@is_parse = false
	end
	def parse
		@is_parse = true
		return nil if is_over?
		begin
			next unless in?
			process_line 
		end until (  out? || is_over?)
		self
	end
	# 行处理函数,必须被重写
	def process_line
		line = @data[@index]
		@object = line
	end
	# 进入条件,默认直接进入
	def in?
		true
	end
	# 退出条件,默认为读完本行直接退出,重写要设置@index的新值
	def out?
		@index += 1
	end
	# 是否数据结构
	def is_over?
		@index >= @data.size
	end
	def get_next
		return nil if is_over?
		return self.class.new(@data,@index).parse
	end
	# 得出剩下的
	def rest
		return [] if is_over?
		next_b = get_next
		return [next_b] + ( next_b.is_over? ? [] : next_b.rest)
	end
	# 找出全部的
	def find_all
		return [] if is_over? && @object == nil
		parse unless @is_parse
		[self] + rest
	end
end
