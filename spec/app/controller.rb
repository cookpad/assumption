class ApplicationController < ActionController::Base; end

class UsersController < ApplicationController
  def new
    render :text => 'ok'
  end

  def show
    render :text => 'ok'
  end

  def update
    render :text => 'ok'
  end

  def index
    render :text => 'ok'
  end
end
Object.const_set(:ApplicationHelper, Module.new)

