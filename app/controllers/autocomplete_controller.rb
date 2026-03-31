class AutocompleteController < ApplicationController
  def users
    query = params[:q].to_s.downcase
    users = Profile.where("lower(display_name) LIKE ?", "#{query}%")
                   .limit(5)
                   .includes(:user)
    render json: users.map { |p| { id: p.user_id, name: p.display_name } }
  end

  def cats
    query = params[:q].to_s.downcase
    cats = Cat.where("lower(name) LIKE ?", "#{query}%").limit(5)
    render json: cats.map { |c| { id: c.id, name: c.name } }
  end
end