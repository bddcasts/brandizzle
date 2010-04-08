module AutoLinkHelper
  remove_const(:AUTO_LINK_RE) if defined?(AUTO_LINK_RE)
  AUTO_LINK_RE = %r{
      ( https?:// | www\. )
      [^\s<]+
    }x

  BRACKETS = { ']' => '[', ')' => '(', '}' => '{' }

  def auto_link(text, *args, &block)
    return '' if text.blank?

    options = args.size == 2 ? {} : args.extract_options!
    unless args.empty?
      options[:link] = args[0] || :all
      options[:html] = args[1] || {}
    end
    options.reverse_merge!(:link => :all, :html => {})

    case options[:link].to_sym
      when :all                         then auto_link_email_addresses(auto_link_urls(text, options[:html], &block), options[:html], &block)
      when :email_addresses             then auto_link_email_addresses(text, options[:html], &block)
      when :urls                        then auto_link_urls(text, options[:html], &block)
    end
  end

  private

    def auto_link_urls(text, html_options = {})
      link_attributes = html_options.stringify_keys
      text.gsub(AUTO_LINK_RE) do
        href = $&
        punctuation = []
        left, right = $`, $'
        # detect already linked URLs and URLs in the middle of a tag
        if left =~ /<[^>]+$/ && right =~ /^[^>]*>/
          # do not change string; URL is already linked
          href
        else
          # don't include trailing punctuation character as part of the URL
          while href.sub!(/[^\w\/-]$/, '')
            punctuation.push $&
            if opening = BRACKETS[punctuation.last] and href.scan(opening).size > href.scan(punctuation.last).size
              href << punctuation.pop
              break
            end
          end

          link_text = block_given?? yield(href) : href
          href = 'http://' + href unless href =~ %r{^[a-z]+://}i

          content_tag(:a, h(link_text), link_attributes.merge('href' => href)) + punctuation.reverse.join('')
        end
      end
    end

    def auto_link_email_addresses(text, html_options = {})
      body = text.dup
      text.gsub(/([\w\.!#\$%\-+]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)+)/) do
        text = $1

        if body.match(/<a\b[^>]*>(.*)(#{Regexp.escape(text)})(.*)<\/a>/)
          text
        else
          display_text = (block_given?) ? yield(text) : text
          mail_to text, display_text, html_options
        end
      end
    end
end