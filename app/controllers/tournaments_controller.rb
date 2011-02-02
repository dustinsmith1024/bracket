class TournamentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  # GET /tournaments
  # GET /tournaments.xml
  def index
    @user = User.find(params[:user_id])
    @tournaments = @user.tournaments

    respond_to do |format|
      format.html # index.html.erb
      format.js   { render :layout => false }
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.xml
  def show
    @user = User.find(params[:user_id])
    @tournament = Tournament.find(params[:id])
    @tags = Tag.order("kind").all
    if @tournament.games.count < 66
      ##CREATE GAMES
      @tournament.build_games
    end

    @games = @tournament.games

    respond_to do |format|
      format.html # show.html.erb
      format.js   { render :layout => false }
    end
  end

  def redo
    @tournament = Tournament.find(params[:id])

    @tournament.clear

    respond_to do |format|
      format.html { redirect_to(user_tournament_url(@tournament.user,@tournament), :notice => 'Rebuilt!') }
      format.js { render :layout => false }
    end
  end


  def questions
    @tournament = Tournament.find(params[:id])
    @user = @tournament.user
    @tags = Tag.order("kind").all

    respond_to do |format|
      format.html # show.html.erb
      format.js { render :layout => false }
    end
  end

  def update_questions
    @tournament = Tournament.find(params[:id])

#    params[:tag].each do |tag|
#    @tournament.tags.destroy_all
    @tournament.tags.delete_all
    @tournament.tags << Tag.find(params[:tag][:animal])
    @tournament.tags << Tag.find(params[:tag][:state])
    @tournament.tags << Tag.find(params[:tag][:color])
    @tournament.tags << Tag.find(params[:tag][:diety])
    @tournament.tags << Tag.find(params[:tag][:conference])
    @tournament.tags << Tag.find(params[:tag][:person])

    respond_to do |format|
      flash[:notice] = 'Questions successfully updated.'
      format.html { redirect_to(tournament_questions_url(@tournament)) }
      format.js
    end
  end

  def add_tag
    @tournament = Tournament.find(params[:id])
    @tag = Tag.find(params[:tag_id])

    @tournament.tags << @tag
    respond_to do |format|
      flash[:notice] = 'Tag was successfully created.'
      format.html { redirect_to(tournament_questions_url(@tournament)) }
      format.js
    end
  end

  def remove_tag
    @tournament = Tournament.find(params[:id])
    @tag = @tournament.tags.find(params[:tag_id])
    respond_to do |format|
      if @tournament.tags.delete(@tag)
        format.html { redirect_to(tournament_questions_url(@tournament), :notice => 'Tag was successfully deleted.') }
        format.js
      else
        format.html { redirect_to(tournament_questions_url(@tournament), :notice => 'Tag was NOT deleted.') }
        format.js
      end
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.xml
  def new
    @user = User.find(params[:user_id])
    @tournament = @user.tournaments.new

    respond_to do |format|
      format.html # new.html.erb
      format.js { render :layout => false }
    end
  end

  # GET /tournaments/1/edit
  def edit
    @user = User.find(params[:user_id])
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.js { render :layout => false }
    end
  end

  # POST /tournaments
  # POST /tournaments.xml
  def create
    @user = User.find(params[:user_id])
    @tournament = @user.tournaments.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to(user_url(@user), :notice => 'Tournament was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.xml
  def update
    @user = User.find(params[:user_id])
    @tournament = @user.tournaments.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to(user_path(@user), :notice => 'Tournament was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @tournament = @user.tournaments.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to(user_url(@user)) }
    end
  end
end
