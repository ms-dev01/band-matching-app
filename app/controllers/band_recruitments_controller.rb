# ApplicationControllerを継承
class BandRecruitmentsController < ApplicationController
    def index
      @band_recruitments = BandRecruitment.all
    end
end
