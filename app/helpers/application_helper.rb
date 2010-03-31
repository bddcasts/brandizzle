module ApplicationHelper
  include Formtastic::SemanticFormHelper
  def active(s)
    case s
    when s = "results"
      controller.controller_name == "brand_results" && (params[:search].blank? || params[:search].try(:[], :follow_up_is) != "true")
    when s = "follow_up"
      controller.controller_name == 'brand_results' && params[:search] && params[:search].try(:[], :follow_up_is) == "true"
    when s = "brands"
      controller.controller_name == "brands"
    when s = "account"
      controller.controller_name == "accounts"
    end
  end
end
