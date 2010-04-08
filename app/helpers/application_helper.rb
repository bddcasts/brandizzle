module ApplicationHelper
  include Formtastic::SemanticFormHelper
  include LinksHelper
  include FiltersHelper
  
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def title_tag
    common_title = 'TalentRockr'
    content_tag(:title, @content_for_title.blank? && "Untitled | #{common_title}" || "#{@content_for_title} | #{common_title}")
  end
  
  def show_title?
    @show_title
  end
end
