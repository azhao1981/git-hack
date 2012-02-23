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
	end
	def parse
		begin
			next unless in?
			process_line 
		end until ( out? )
		@object
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
end
