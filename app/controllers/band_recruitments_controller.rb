# ApplicationControllerを継承
class BandRecruitmentsController < ApplicationController
    def index
      @band_recruitments = BandRecruitment.all
    end

    def show
      @band_recruitment = BandRecruitment.find(params[:id])
    end

    def new
      @band_recruitment = BandRecruitment.new

      # 募集パートと必要人数の初期値を設定
      RecruitmentPart.parts.keys.each do |part|
        @band_recruitment.recruitment_parts.build(
          part: part,
          max_count: 0
          )
      end
    end

  # private
  # def band_recruitment_params
  #   # formから送信されるパラメータのうち、許可したパラメータのみ受け取る
  #   params.require(:band_recruitment).permit(
  #     :avatar,
  #     :nickname,
  #     :gender,
  #     :birth_date,
  #     :part,
  #     :experience_year,
  #     :experience_month,
  #     :activity_style,
  #     :practice_style,
  #     :music_type,
  #     :wants_live_performance,
  #     :sns_links,
  #     :bio,
  #     activity_genre_ids: [],
  #     activity_area_ids: [],
  #     personality_ids: [],
  #     favorite_band_ids: []
  #   )
  # end

  # recruitment_parts_attributes: [:part, :max_count]
end
