#!/usr/bin/env ruby

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require "bundler/setup"
require "alfred"

require 'gemoji'
require_relative 'emoji_characters'

def icon_hash(emoji)
  path = File.join(Emoji.images_path, 'emoji', emoji.image_filename)
  { :type => 'default', :name => path }
end

def emoji_item(emoji)
  emoji_code = ":#{emoji.name}:"
  {
    :uid => emoji_code,
    :title => emoji_code,
    :icon => icon_hash(emoji),
    :arg =>  EmojiCharacters.from_code(emoji.name) || emoji_code
  }
end

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  if ARGV.size == 1
    query = Regexp.escape(ARGV.first)

    items = Emoji.all.map(&:name).grep(/#{query}/).each do |code|
      fb.add_item(emoji_item(Emoji.find_by_alias(code)))
    end

    puts fb.to_xml(ARGV)
  end
end
