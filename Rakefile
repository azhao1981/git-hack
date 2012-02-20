require "bundler/gem_tasks"

desc "Generate a binary for each of our commands"
task :generate_binaries do
	base_dir = File.dirname(__FILE__)
	require "#{base_dir}/lib/git-hack"

	require 'fileutils'
	FileUtils.mkdir_p "#{base_dir}/bin"
	GitHack.commands.keys.each { |cmd|
		filename = "#{base_dir}/bin/git-#{cmd}"
		File.open(filename, 'w') { |out|
			out.puts %Q{#!/usr/bin/env ruby

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))

require 'git-hack'

GitHack.run('#{cmd}', ARGV)
}
	}
	`chmod a+x #{filename}`
	`cd #{base_dir} && git add #{filename}`
	puts "Wrote #{filename}"
	}
end
task :build => :generate_binaries
