require "octopress-image-tag/version"

# Title: Simple Image tag for Jekyll
# Authors: Brandon Mathis http://brandonmathis.com
#          Felix Schäfer, Frederic Hemberger
#

module Octopress
  module Tags
    module ImageTag
      class Tag < Liquid::Tag
        @img = nil

        def initialize(tag_name, markup, tokens)
          if markup =~ /title:['|"](.+?)['|"]/
            @title = $1.strip
          end

          markup = markup.gsub(/title:['|"].+?['|"]/, '').strip

          if markup =~ /(?<class>\S.*\s+)?(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?:\s+(?<width>\d\S+))?(?:\s+(?<height>\d\S+))?(?<alt>\s+.+)?/i
            attributes = ['class', 'src', 'width', 'height', 'alt']
            @img = attributes.reduce({}) { |img, attr| img[attr] ||= $~[attr].strip if $~[attr]; img }
            text = @img['alt']

            # Allow parsing "title" "alt"
            if text =~ /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/
              @img['title']  = title
              @img['alt']    = alt
            else
              # Set alt text and title from text
              @img['alt'].gsub!(/"/, '') if @img['alt']
            end
          end

          @img['title'] ||= @title
          @img['alt'] ||= @title
          super
        end

        def render(context)
          if @img
            "<img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>"
          else
            "Error processing input, expected syntax: {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
          end
        end
      end
    end
  end
end

Liquid::Template.register_tag('img', Octopress::Tags::ImageTag::Tag)

if defined? Octopress::Docs
  Octopress::Docs.add({
    name:        "Octopress Image Tag",
    gem:         "octopress-image-tag",
    description: "A nice image tag for Jekyll sites.",
    path:        File.expand_path(File.join(File.dirname(__FILE__), "../")),
    source_url:  "https://github.com/octopress/image-tag",
    version:     Octopress::Tags::ImageTag::VERSION
  })
end
