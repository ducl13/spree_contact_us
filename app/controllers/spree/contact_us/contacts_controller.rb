class Spree::ContactUs::ContactsController < Spree::StoreController

  helper "spree/products"
  def create
    @contact = Spree::ContactUs::Contact.new(params[:contact_us_contact])

    success = verify_recaptcha(model: @contact, action: 'contact_us', minimum_score: 0.5)
    checkbox_success = verify_recaptcha unless success
    if success || checkbox_success
      if @contact.save
        if Spree::ContactUs::Config.contact_tracking_message.present?
          flash[:contact_tracking] = Spree::ContactUs::Config.contact_tracking_message
        end
        redirect_to(spree.root_path, :notice => Spree.t('contact_us.notices.success'))
      else
        render :new
      end
    else
      if !success
        @show_checkbox_recaptcha = true
      end
      render :new
    end
  end

  def new
    @contact = Spree::ContactUs::Contact.new
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  private

  def accurate_title
    Spree.t(:contact_us_title)
  end

end
