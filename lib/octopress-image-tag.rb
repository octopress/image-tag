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
          @markup = markup
          super
        end

        def render(context)
          begin
            attributes = image(context).collect do |k,v|
              "#{k}=\"#{v}\"" if v
            end.join(" ")

            "<img #{attributes}>"
          rescue
            raise "Error processing input, expected syntax: {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
          end
        end

        def image(context)
          @markup = process_liquid(context)

          title = /title:['|"](.+?)['|"]/
          @title = @markup.scan(title).flatten.compact.last
          @markup.gsub!(title, '')

          if @markup =~ /(?<class>\S.*\s+)?(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?:\s+(?<width>\d\S+))?(?:\s+(?<height>\d\S+))?(?<alt>\s+.+)?/i
            attributes = ['class', 'src', 'width', 'height', 'alt']
            image = attributes.reduce({}) { |img, attr| img[attr] ||= $~[attr].strip if $~[attr]; img }
            text = image['alt']

            # Allow parsing "title" "alt"
            if text =~ /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/
              image['title']  = title
              image['alt']    = alt
            else
              # Set alt text and title from text
              image['alt'].gsub!(/"/, '') if image['alt']
            end
          end

          image['title'] ||= @title
          image['alt'] ||= @title

          image
        end

        def process_liquid(context)
          Liquid::Template.parse(@markup).render!(context.environments.first)
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
