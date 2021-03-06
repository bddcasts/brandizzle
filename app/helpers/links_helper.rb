module LinksHelper
  include AutoLinkHelper
  
  def active(s)
    case s
    when s = "dashboard"
      controller.controller_name == "dashboard"
    when s = "results"
      request.path =~ /^\/brand_results/
    when s = "brands"
      controller.controller_name == "brands"
    when s = "account"
      controller.controller_name == "accounts"
    when s = "team"
      request.path =~ /^\/team/
    when s = "account"
      controller.controller_name == "accounts"
    end
  end  
  
  def link_to_remote_update(label, url, options={})
    link_to label, url,
      {
        :id => options.delete(:id),
        :class => options.delete(:class),
        :"data-method" => :put,
        :"data-remote" => true,
      }
  end
end