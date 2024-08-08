class CardsController < ApplicationController
  before_action :set_card, only: %i[ show edit update destroy ]

  def index
    @cards = Card.all
    @card = Card.new
  end

  def show
  end

  def edit
    @card = Card.find(params[:id])
  end

  def create
    @card = Card.new(card_params)
  
    respond_to do |format|
      if @card.save
        Turbo::StreamsChannel.broadcast_update_to "cards", target: "cards", partial: "cards/reload"
        format.turbo_stream
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

  def destroy
    @card.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
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