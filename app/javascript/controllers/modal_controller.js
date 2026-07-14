import { Controller } from "@hotwired/stimulus";

// StimulusのControllerを継承したModalControllerを作成
export default class extends Controller {
  close() {
    // モーダルの非表示
    document.querySelector(".modal-container").style.display = "none";
  }

  stop(event) {
    // イベントが親へ伝わるのを止める
    event.stopPropagation();
  }
}
