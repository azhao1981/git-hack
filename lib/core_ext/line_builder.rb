# Copyright @ weizhao 2012
# 把线性数据转化成对象的线性构造器
# 给定@data,@index就可以从 #object #all_object 方法中得到构造到的对象
# 一般需要重写 #process_line 行处理函数
# 			   #out? 退出条件处理函数
#
class LineBuilder
	attr_accessor :data,:index
	def initialize(data,index=0)
		@data = data 			# 要处理的array数据
		@index = index 			# 处理数据的位置,从0起
		@data_size = data.size  # 这个会经常调用 
		@object = nil   		# 保存要构造的对象,调用#parse后可以使用
		@all_objects = nil 		# 保存所有能构造的对象, 调用#find_all后使用
		@is_parse = false  # 是否解析过的标志
	end

	#
	# parse 分析函数,最好不要重写,一般这可就可以了
	#
	def parse
		@is_parse = true
		return nil if is_over?
		begin
			next unless in?
			process_line 
		end until (  out? || is_over?)
		self
	end
	#
	# 行处理函数,必须被重写
	# 默认是读一行,把数据做为对象传给object
	#
	def process_line
		line = @data[@index]
		@object = line
	end
	def object
		@object ||= parse.object
	end
	def all_objects
		@all_objects ||= find_all.each { |b| b.object } 
	end
	#
	# 进入条件,默认直接进入
	#
	def in?
		true
	end
	#
	# 退出条件,默认为读完本行直接退出,重写要设置@index的新值
	# 即线性构造器每次只取一行
	#
	def out?
		@index += 1
	end
	# 是否数据已经遍历结束
	def is_over?
		@index >= @data_size
	end
	# 得到下一个数据
	# 运行两次不会得到下一个的下一个数据
	def get_next
		return nil if is_over?
		return self.class.new(@data,@index).parse
	end
	# 得到剩下的数据
	def rest
		return [] if is_over?
		next_b = get_next
		return [next_b] + next_b.rest #( next_b.is_over? ? [] : next_b.rest)
	end
	# 为@data结构全部的数据
	def find_all
		return [] if is_over? && @object == nil  # 给定的index已经超出data
		parse unless @is_parse
		[self] + rest
	end
end
