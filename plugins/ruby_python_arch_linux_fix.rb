require 'pygments'

if !!RUBY_PLATFORM['linux']
    RubyPython.configure :python_exe => '/usr/bin/python2.7'
end