# 
# ruby-git 库有一些错误,这是补丁
#


module Git
	class Lib
		def full_log_commits(opts = {})
			arr_opts = ['--pretty=raw']
			arr_opts << "-#{opts[:count]}" if opts[:count]
			arr_opts << "--skip=#{opts[:skip]}" if opts[:skip]
			arr_opts << "--since=#{opts[:since]}" if opts[:since].is_a? String
			arr_opts << "--until=#{opts[:until]}" if opts[:until].is_a? String
			arr_opts << "--grep=#{opts[:grep]}" if opts[:grep].is_a? String
			arr_opts << "--author=#{opts[:author]}" if opts[:author].is_a? String
			arr_opts << "#{opts[:between][0].to_s}..#{opts[:between][1].to_s}" if (opts[:between] && opts[:between].size == 2)
			arr_opts << opts[:object] if opts[:object].is_a? String
			arr_opts << '--' << opts[:path_limiter] if opts[:path_limiter].is_a? String
			puts arr_opts.to_s_s

			full_log = command_lines('log', arr_opts, true)
			# modify by weizhao. commit must be specify
			# putsrocess_commit_data(full_log)
			process_commit_data(full_log,"commit")
		end
	end
end
