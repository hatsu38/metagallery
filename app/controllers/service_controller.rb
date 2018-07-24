class ServiceController < ApplicationController
  def index
    @services = Service.all.order("created_at DESC")
  end

  def metaget
    url = params[:data][:text]
    page = MetaInspector.new(url)
    meta_keywords = page.meta_tag['name']['keywords']
    keywords_ary = meta_keywords.split(",")
    results = { :meta_url=> page.root_url,
                :meta_title => page.title,
                :meta_description => page.description,
                :meta_favicon => page.images.favicon,
                :meta_ogpimg => page.images.best,
                :meta_keyword => keywords_ary,
                :meta_domain => page.host,
    }
    render partial: 'metaget', locals: { :results => results }
  end
end
