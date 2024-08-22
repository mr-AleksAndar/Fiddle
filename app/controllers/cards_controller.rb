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
        Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "main-container",
        partial: "cards/reload"
        
        format.turbo_stream { render turbo_stream: turbo_stream.replace("main-container", partial: "cards/reload") }
        format.html { redirect_to cards_path, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_card', partial: 'form', locals: { card: @card }) }
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
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "user_scores_#{@card.id}",
        partial: "cards/user_scores",
        locals: { card: @card }
  
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "admin_actions_#{@card.id}",
        partial: "cards/admin_actions",
        locals: { card: @card }
    end
  end
  
  def hide_scores
    if @card.update(visible: false)
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "user_scores_#{@card.id}",
        partial: "cards/user_scores",
        locals: { card: @card }
  
      Turbo::StreamsChannel.broadcast_replace_to "cards",
        target: "admin_actions_#{@card.id}",
        partial: "cards/admin_actions",
        locals: { card: @card }
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