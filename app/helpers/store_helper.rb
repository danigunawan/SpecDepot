module StoreHelper

  def page_title
    @page_title || t('.title')
  end

end
