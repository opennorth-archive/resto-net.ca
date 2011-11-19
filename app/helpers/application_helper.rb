module ApplicationHelper
  def title
    content_for?(:title) ? content_for(:title) : t(:app_title)
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : t(:meta_description)
  end
end
