class PagesController < ApplicationController
  def home

    respond_to do |format|
      format.html # index.html.erb
      format.js  { render :layout => false }
    end

  end

  def info

    respond_to do |format|
      format.html # index.html.erb
      format.js  { render :layout => false }
    end

  end

  def contact
    respond_to do |format|
      format.html # index.html.erb
      format.js  { render :layout => false }
    end

  end

end
