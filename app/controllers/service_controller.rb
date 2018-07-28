class ServiceController < ApplicationController
  def index
    @services = Service.all.order("created_at DESC")
    keyword_ary_top10 = ServiceKeyword.group(:keyword_id).order("count_all desc").limit(10).count
    @keywords = []
    keyword_ary_top10.each do |keyword|
      @keywords << Keyword.find_by(id: keyword.first)
    end
  end

  def create
    keywords = params[:meta][:keyword]
    @service = Service.new(service_params)
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
    begin
      page = MetaInspector.new(url)
      flash.now[:success] = "取得しました"
    rescue
      flash.now[:danger] = "取得できませんでした"
      url = "https://example.com/"
      page = MetaInspector.new(url)
    end
    meta_keywords = page.meta_tag['name']['keywords']
    if meta_keywords
      keywords_ary = meta_keywords.split(",")
    else
      keywords_ary = []
    end
    if page.images.favicon
      favicon = page.images.favicon
    else
      favicon = "assets/noimage.png"
    end
    if page.meta['og:image']
      ogpimg = page.meta['og:image']
    else
      ogpimg = "assets/noimage.png"
    end
    results = { :meta_url=> page.root_url,
                :meta_title => page.title,
                :meta_description => page.description,
                :meta_favicon => favicon,
                :meta_ogpimg => ogpimg,
                :meta_keyword =>keywords_ary,
                :meta_domain => page.host,
    }
    render partial: 'metaget', locals: { :results => results }
  end

  private
  def service_params
    params.require(:service).permit(:url,:domain,:title,:description,:favicon,:ogpimg)
  end
end
