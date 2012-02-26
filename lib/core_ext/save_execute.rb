# 标记方法安全运行的模块
#
module SaveExecute
	def ready_to_execute
		@is_success = false
	end
	def execute_success
		@is_success = true
	end
	def success?
		@is_success
	end
end
