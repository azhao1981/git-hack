# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :cli=>"--color",:version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/commands/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/git-hack/(.+)\.rb$})     { |m| ["spec/#{m[1]}_spec.rb",
	  											"*.rb"] }
  watch(%r{^lib/core_ext/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
	  											
  watch('spec/spec_helper.rb')  { "spec" }
  
end

