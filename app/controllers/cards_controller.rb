class CardsController < ApplicationController
  before_action :set_card, only: %i[show edit update destroy reveal_scores hide_scores]


  def index
    @cards = Card.all
    @card = Card.new
  end

  
      def show
        @card = Card.find(params[:id])
        @scores = @card.scores.includes(:user) # Preload users to avoid N+1 queries
      end

  def edit
    @card = Card.find(params[:id])
  end
  def create
    @card = Card.new(card_params)
  
    respond_to do |format|
      if @card.save
        # 1. Broadcast a Turbo Stream to all other users to reload their page
        Turbo::StreamsChannel.broadcast_replace_to "cards",
          target: "main-container",
          partial: "cards/reload" # This partial contains JS to reload the page
  
        # 2. Respond to the user who submitted the request with a Turbo Stream update
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("main-container", partial: "cards/reload")
        end
  
        # Optionally respond with an HTML redirect for non-Turbo users
        format.html { redirect_to cards_path, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('new_card', partial: 'form', locals: { card: @card })
        end
  
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.turbo_stream
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def reveal_scores
    if @card.update(visible: true)
      # Broadcast the user scores update to all subscribed users
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "user_scores_#{@card.id}",
        partial: "cards/user_scores",
        locals: { card: @card }
  
      # Broadcast the admin actions update to all subscribed users
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "admin_actions_#{@card.id}",
        partial: "cards/admin_actions",
        locals: { card: @card }
  
      respond_to do |format|
        format.turbo_stream # This will automatically render reveal_scores.turbo_stream.erb for the initiating user
        format.html { redirect_to cards_path, notice: 'Scores revealed successfully.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to cards_path, alert: 'Failed to reveal scores.' }
      end
    end
  end
  
  def hide_scores
    if @card.update(visible: false)
      # Broadcast the user scores update to all subscribed users
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "user_scores_#{@card.id}",
        partial: "cards/user_scores",
        locals: { card: @card }
  
      # Broadcast the admin actions update to all subscribed users
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "admin_actions_#{@card.id}",
        partial: "cards/admin_actions",
        locals: { card: @card }
  
      respond_to do |format|
        format.turbo_stream # This will automatically render hide_scores.turbo_stream.erb for the initiating user
        format.html { redirect_to cards_path, notice: 'Scores hidden successfully.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to cards_path, alert: 'Failed to hide scores.' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @card.destroy
        Turbo::StreamsChannel.broadcast_update_to "cards", target: "cards", partial: "cards/reload"
        format.turbo_stream
        format.html { redirect_to cards_path, notice: 'Card was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('cards', partial: 'cards/reload') }
        format.html { redirect_to cards_path, alert: 'Unable to delete card.' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:url, :visible)
  end
end