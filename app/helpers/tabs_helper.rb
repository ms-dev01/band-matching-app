module TabsHelper
  def active_parent_tab(controller:, filter: nil)
    # 現在のページのcontrollerと一致しなければ処理終了
    return unless params[:controller] == controller

    if params[:controller] == "band_recruitments"
      current_filter = params[:filter].presence || nil
      if current_filter == filter
        "active"
      end
    else
      "active"
    end
  end

  def active_child_tab(controller:, filter:)
    current_filter = params[:filter].presence || "sent"

    if params[:controller] == controller && current_filter == filter
      "active"
    end
  end
end
