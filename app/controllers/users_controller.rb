class UsersController < ApplicationController
  before_filter :authenticate_user!
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.js  { render :layout => false }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = current_user
    @tournaments = @user.tournaments
    @tags = Tag.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
      format.js  { render :layout => false }
    end
  end

  # GET /users/1/edit
  def edit
    @user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.js { render :layout => false }
    end

  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
#    @user = User.find(params[:id])

    current_user.team = Team.find(params[:user][:team_id])
    current_user.team.save!

    respond_to do |format|
      if current_user.update_attributes(params[:user])
        format.html { redirect_to(pages_table_path(), :notice => 'User was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
