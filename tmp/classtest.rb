class A
	def selfclass
		self.class
	end
	def get_next
		selfclass.new
	end
end
class B < A
end
a = A.new
b = B.new
puts a.class
puts a.selfclass.new
puts b.class
puts b.get_next
