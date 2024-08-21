class ScoresController < ApplicationController
  def create
    @score = Score.new(score_params)
  
    respond_to do |format|
      if @score.save
        # Broadcast the score update to all users
        Turbo::StreamsChannel.broadcast_replace_to "cards",
          target: "user_scores_#{@score.card_id}",
          partial: "cards/user_scores",
          locals: { card: @score.card }
  
        format.turbo_stream
        format.html { redirect_to @score.card, notice: 'Score was successfully created.' }
        format.json { render :show, status: :created, location: @score }
      else
        # Handle the case where the score wasn't saved (e.g., duplicate score)
        format.html { redirect_to @score.card, alert: @score.errors.full_messages.join(', ') }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def score_params
    params.require(:score).permit(:user_id, :card_id, :score)
  end
end