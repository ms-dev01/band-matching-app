# ApplicationControllerを継承
class BandRecruitmentsController < ApplicationController
    def index
      @band_recruitments = BandRecruitment.all
    end

    def show
      @band_recruitment = BandRecruitment.find(params[:id])
    end
end
