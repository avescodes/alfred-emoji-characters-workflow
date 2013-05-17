#!/usr/bin/env ruby

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require "bundle/bundler/setup"
require "alfred"

require 'gemoji'
require 'emoji_characters'

def icon_hash(emoji)
  path = File.join(Emoji.images_path, 'emoji', "#{emoji}.png")
  { :type => 'default', :name => path }
end

def emoji_item(emoji_name)
  emoji_code = ":#{emoji_name}:"
  {
    :uid => emoji_code,
    :title => emoji_code,
    :icon => icon_hash(emoji_name),
    :arg =>  EmojiCharacters.from_code(emoji_name) || emoji_code
  }
end

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  query = Regexp.escape(ARGV.first)

  items = Emoji.names.grep(/#{query}/).each do |code|
    fb.add_item(emoji_item(code))
  end

  puts fb.to_xml(ARGV)
end
