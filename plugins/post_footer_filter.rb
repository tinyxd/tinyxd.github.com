#
# post_footer_filter.rb
# Append every post some footer infomation like original url 
# Written by Kevin Lynx . 
# Modified by Tiny (http://tinyxd.me/) .
# Email: admin#tinyxd.me
# Date: 1.16.2013
#
require './plugins/post_filters'

module AppendFooterFilter
  def append(post)
     author = post.site.config['author']
     url = post.site.config['url']
     pre = post.site.config['original_url_pre']
    keyword_pre = post.site.config['original_keyword_pre']
     post.content + %Q[<p class='post-footer'>#{pre or "original link:"}
<a href='#{post.full_url}'>#{post.full_url}</a><br/>
&nbsp;Written by <a href='#{url}'>#{author}</a>
&nbsp;Posted at <a href='#{url}'>#{url}</a><br/>
&nbsp;#{keyword_pre or "Keywords :"} {{ page.keywords }}</p>]
  end 
end

module Jekyll
  class AppendFooter < PostFilter
    include AppendFooterFilter
    def pre_render(post)
      post.content = append(post) if post.is_post?
    end
  end
end

Liquid::Template.register_filter AppendFooterFilter