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
    keywords_ary = get_keyword(page)
    favicon = get_img(page.images.favicon,page)
    ogpimg = get_img(page.meta['og:image'],page)
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

  def get_keyword(page)
    meta_keywords = page.meta_tag['name']['keywords']
    if meta_keywords
      return meta_keywords.split(",")
    else
      return []
    end
  end

  def get_img(img,page)
    if img
      return "noimage.png" unless img.include?("png") || img.include?("jpg") || img.include?("jpeg") || img.include?("gif") || img.include?("ico")
      if img.start_with?("http")
        return img
      else
        return page.root_url.chop + img
      end
    else
      return "noimage.png"
    end
  end

  def get_ogpimg(page)
    if page.meta['og:image']
      if page.meta['og:image'].start_with?("http")
        return page.meta['og:image']
      else
        return page.root_url.chop + page.meta['og:image']
      end
    else
      return "noimage.png"
    end
  end

end
