module LinksHelper
  include AutoLinkHelper
  
  def active(s)
    case s
    when s = "results"
      controller.controller_name == "brand_results"
    when s = "brands"
      controller.controller_name == "brands"
    when s = "account"
      controller.controller_name == "accounts"
    when s = "team"
      request.path =~ /^\/team/
    when s = "invitation"
      controller.controller_name == "invitations"
    end
  end  
end