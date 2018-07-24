class ServiceController < ApplicationController
  def index
    @services = Service.all.order("created_at DESC")
  end

  def create
    keywords = params[:meta][:keyword]
    @service = Service.new(service_params)
    binding.pry
    if @service.save
      if keywords
        keywords_ary = keywords.split(" ")
        keywords_ary.each do |keyword|
          if Keyword.exists?(:name => keyword)
            word = Keyword.find_by(name: keyword)
          else
            word = Keyword.create(
              name: keyword
            )
          end
          ServiceKeyword.create(service_id: @service.id,keyword_id: word.id)
        end
      end
      redirect_to root_path
    end
  end

  def metaget
    url = params[:data][:text]
    page = MetaInspector.new(url)
    meta_keywords = page.meta_tag['name']['keywords']
    keywords_ary = meta_keywords.split(",") if meta_keywords
    if page.images.favicon
      favicon = page.images.favicon
    else
      favicon = "assets/noimage.png"
    end
    if page.images.best
      ogpimg = page.images.best
    else
      ogpimg = "assets/noimage.png"
    end
    results = { :meta_url=> page.root_url,
                :meta_title => page.title,
                :meta_description => page.description,
                :meta_favicon => favicon,
                :meta_ogpimg => ogpimg,
                :meta_keyword => keywords_ary,
                :meta_domain => page.host,
    }
    render partial: 'metaget', locals: { :results => results }
  end

  private
  def service_params
    params.require(:service).permit(:name,:url,:domain,:title,:description,:favicon,:ogpimg)
  end


end
