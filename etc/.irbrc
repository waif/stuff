# Enable tab-completion.
require 'irb/completion'
# Auto-indentation.
IRB.conf[:AUTO_INDENT] = true

# Readline-enable prompts.
require 'irb/ext/save-history'
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_PATH] = File::expand_path("~/.irb.history")

require 'rubygems'
require 'interactive_editor'
require 'what_methods'
require 'rubygems'
require 'wirble'
require 'bond'
require 'hirb'

Bond.start
Hirb.enable

Wirble.init
Wirble.colorize
