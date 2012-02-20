require "git-hack/version"

module GitHack
end

Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |f| require f }
