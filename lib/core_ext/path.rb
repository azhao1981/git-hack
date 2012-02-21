# -*- encoding : utf-8 -*-
require 'pathname'

module PathCommon
	# 给定相对项目根目录路径，返回绝对路径
	def project_file(path)
		join(project_dir,path)
	end
	# 返回项目绝对目录
  def project_dir
    absolute_path("#{File.dirname(__FILE__)}/../../")
  end
  def absolute_path(path,dir=Dir.pwd)
  	Pathname.new(path).relative? ? File.expand_path(path,dir) : File.expand_path(path,"/")
  end
  # require file from project dir
  def require_p(path)
    require join(project_dir,path)
  end
  def join(path,file=".")
	  File.join(path,file)
  end
end

