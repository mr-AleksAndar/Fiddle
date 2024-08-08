class ScoresController < ApplicationController
    before_action :set_score, only: %i[ show edit update destroy ]
  
    def create
      @score = Score.new(score_params)
  
      respond_to do |format|
        if @score.save
          format.turbo_stream
          format.html { redirect_to @score.card, notice: 'Score was successfully created.' }
          format.json { render :show, status: :created, location: @score }
        else
          format.html { redirect_to @score.card, alert: 'Unable to create score.' }
          format.json { render json: @score.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def update
      respond_to do |format|
        if @score.update(score_params)
          format.turbo_stream
          format.html { redirect_to @score.card, notice: 'Score was successfully updated.' }
          format.json { render :show, status: :ok, location: @score }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @score.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @score.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @score.card, notice: 'Score was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    private
  
    def set_score
      @score = Score.find(params[:id])
    end
  
    def score_params
      params.require(:score).permit(:user_id, :card_id, :score)
    end
  end