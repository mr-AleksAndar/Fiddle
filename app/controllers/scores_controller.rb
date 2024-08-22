class ScoresController < ApplicationController
  before_action :set_card, only: [:create]

  def create
    @score = Score.new(score_params)

    respond_to do |format|
      if @score.save
        # Broadcast the new score to all users, appending it to the list
        Turbo::StreamsChannel.broadcast_append_to "user_scores_#{@score.card_id}",
          target: "user_scores_#{@score.card_id}",
          partial: "cards/single_score",
          locals: { score: @score, card: @card }

        format.turbo_stream
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_score_form", partial: "scores/form", locals: { score: @score })
        end
      end
    end
  end

  private

  def set_card
    @card = Card.find(params[:card_id])
  end

  def score_params
    params.require(:score).permit(:user_id, :card_id, :score)
  end
end