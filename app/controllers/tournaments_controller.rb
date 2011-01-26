class TournamentsController < ApplicationController
  # GET /tournaments
  # GET /tournaments.xml
  def index
    @user = User.find(params[:user_id])
    @tournaments = @user.tournaments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tournaments }
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.xml
  def show
    @user = User.find(params[:user_id])
    @tournament = Tournament.find(params[:id])
    @tags = Tag.order("kind").all
    if @tournament.games.empty?
      ##CREATE GAMES
      @tournament.build_games
    end

    @games = @tournament.games

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tournament }
    end
  end

  def redo
    @tournament = Tournament.find(params[:id])

    @tournament.clear

    respond_to do |format|
      format.html { redirect_to(user_url(@tournament.user,@tournament), :notice => 'Rebuilt!') }
#      format.html # show.html.erb
      format.xml  { render :xml => @tournament }
    end
  end


  def questions
    @tournament = Tournament.find(params[:id])
    @user = @tournament.user
    @tags = Tag.order("kind").all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tournament }
    end
  end

  def add_tag
    @tournament = Tournament.find(params[:id])
    @tag = Tag.find(params[:tag_id])

    @tournament.tags << @tag
    respond_to do |format|
        format.html { redirect_to(tournament_questions_url(@tournament), :notice => 'Tag was successfully created.') }
    end
  end

  def remove_tag
    @tournament = Tournament.find(params[:id])
    @tag = @tournament.tags.find(params[:tag_id])
    respond_to do |format|
      if @tournament.tags.delete(@tag)
        format.html { redirect_to(tournament_questions_url(@tournament), :notice => 'Tag was successfully deleted.') }
      else
        format.html { redirect_to(tournament_questions_url(@tournament), :notice => 'Tag was NOT deleted.') }
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
      format.xml  { render :xml => @tournament }
    end
  end

  # GET /tournaments/1/edit
  def edit
    @user = User.find(params[:user_id])
    @tournament = Tournament.find(params[:id])
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tournament.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
    end
  end
end
