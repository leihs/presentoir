class ApplicationController < ActionController::Base

  def index
    respond_with_presenter(UserDashboard.new(user: current_user, **pagination_params)
  end

  private

  # A lil helper for having a JSON API (think `next.js` or similar)
  def respond_with_presenter(presenter)
    fail 'Not a Presenter⁉️' unless presenter.is_a?(ApplicationPresenter)
    respond_to do |format|
      format.html { render(locals: presenter.dump) }
      format.json { render(json: JSON.pretty_generate(presenter.dump)) }
    end
  end

  def pagination_params
    params.slice(:page, :per_page).map(&:to_i)
  end

end

# Basic ApplicationPresenter and ApplicationRecordPresenter are generated on install

class Presenter::UserDashboard < ApplicationPresenter
  # NOTE: initializer is optional, if more args than the record, or custom init is needed
  def initialize(user:, page: 1, per_page: 12)
    @user = user
    @posts = user.posts_from_friends
      .reorder(created_at: 'DESC')
      .limit(per_page).offset((page - 1) * per_page)
  end

  def timeline
    @posts.map { |p| Post.new(p) }
  end

  def profile
    UserProfile::Full.new(@user)
  end

  def in_case_you_missed
    # FIXME: query
    user.favs_from_friends.top_posts.map { |p| Post.new(p) }
  end

  def users_by_id
    # FIXME: query
    @posts.joins(:users).distinct
      .map { |u| [u.id, UserProfile.new(u)] }.to_h
  end
end

# # #

class Presenter::Post < ApplicationRecordPresenter
  delegate_to_record :user_id, :text, :date, :location

  def fav_count
    ::UserPostFavorites.where(user_id: record.id).count
  end

  def is_faved
    ::UserPostFavorites.where(user_id: record.id).exists?
  end
end

class Presenter::UserProfile < ApplicationRecordPresenter
  delegate_to_record :name, :display_name, :verified

  def image_url
    user_avatar_url(record)
  end
end

class Presenter::UserProfile::Full < UserProfile
  def posts_count
    record.posts.count
  end

  def followers_count
    ::UserFollows.where(follows_user_id: record.id).count
  end

  def following_count
    ::UserFollows.where(user_id: record.id).count
  end
end
