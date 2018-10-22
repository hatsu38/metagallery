class ServiceController < ApplicationController
  before_action :set_service,only: [:show,:edit,:update,:destroy]

  def index
    @services = Service.all.order("created_at DESC")
    keyword_ary_top10 = ServiceKeyword.group(:keyword_id).order("count_all desc").limit(10).count
    @keywords = []
    keyword_ary_top10.each do |keyword|
      @keywords << Keyword.find_by(id: keyword.first)
    end
  end

  def contact
    message = params[:inquiry][:message]
    email = params[:inquiry][:email]
    inquiry = Inquiry.new(email: email, message: message)
    inquiry.save
    InquiryMailer.send_mail(inquiry).deliver_now
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

  def show
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @service.destroy!
    redirect_to root_path, notice: '削除しました'
  end

  def metaget
    url = params[:data][:text]
    begin
      post_page = MetaInspector.new(url)
      page = MetaInspector.new(post_page.root_url)
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
    @can_add = can_add(results)
    render partial: 'metaget', locals: { :results => results }
  end

  private
  def service_params
    params.require(:service).permit(:url,:domain,:title,:description,:favicon,:ogpimg)
  end

  def set_service
    @service = Service.find(params[:id])
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
      if img.start_with?("https") || is_ssl(page)==false
        return img
      elsif img.start_with?("http") && is_ssl(page)
        return img.sub(/http/, 'https')
      else
        return page.root_url.chop + img
      end
    else
      return "noimage.png"
    end
  end

  def is_ssl(page)
    if page.scheme == "https"
      return true
    else
      return false
    end
  end

  def can_add(results)
    if Service.exists?(:domain=>results[:meta_domain])
      return false
    elsif results[:meta_ogpimg] == "noimage.png"
      return false
    elsif results[:meta_title] && results[:meta_domain]
      return true
    else
      return false
    end
  end
end
