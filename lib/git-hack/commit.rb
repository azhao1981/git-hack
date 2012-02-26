# Commit类对应git当中的提交对象
require_relative "../git-hack"


module GitHack
	class Commit
		attr_accessor :message,:sha,:parent,:tree,:author,:committer
		def initialize(hash)
			@sha = hash['sha']
			@message = hash['message']
			@parent = hash['parent']
			@tree = hash['tree']
			@author = hash['author']
			@committer = hash['committer']
		end
	end
end


