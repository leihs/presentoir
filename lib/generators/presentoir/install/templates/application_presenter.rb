class ApplicationPresenter < Presentoir::Presenter
  include Rails.application.routes.url_helpers

  def type # not used in ruby land! (js models only)
    self.class.name.demodulize
  end

  def _presenter
    return if Rails.env != 'development'
    self.class.name
  end

  private

  def delegate_to(inst_var, *args)
    args.each { |m| delegate m, to: inst_var }
  end

  def prepend_url_context(url = '')
    # FIXME: RAILS BUG https://github.com/rails/rails/pull/17724
    context = Rails.application.routes.relative_url_root
    context.present? ? context + url : url
  end
end
