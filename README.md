# Octopress Image Tag

A nice image tag for Jekyll sites.

## Installation

### Using Bundler

Add this gem to your site's Gemfile in the `:jekyll_plugins` group:

    group :jekyll_plugins do
      gem 'octopress-image-tag'
    end

Then install the gem with Bundler

    $ bundle

### Manual Installation

    $ gem install octopress-image-tag

Then add the gem to your Jekyll configuration.

    gems:
      - octopress-image-tag

## Usage

```
{% img [class names] url [width [height]] "[alt text]" [title:""] %}
```

Examples:

```
{% img /images/ninja.png "Ninja Attack!" %}
{% img left half http://site.com/images/ninja.png title:"Hidden Ninja" %}
{% img {{ site.cdn }}/images/ninja.png 150px 150px %}
```

Output:

```
<img src="/images/ninja.png" alt="Ninja Attack!" >
<img class="left half" src="http://site.com/images/ninja.png" alt="Hidden Ninja" title="Hidden Ninja" >
<img src="http://some.cdn.io/images/ninja.png" width="150px" height="150px" alt="Ninja in the shadows" title="Hidden Ninja">
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/image-tag/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
