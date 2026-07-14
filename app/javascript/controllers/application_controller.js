import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // 参加希望フォームの表示/非表示
  show() {
    document.querySelector(".js-application-container").style.display = "block";
    document.querySelector(".btn-container").style.display = "none";
  }

  hide() {
    document.querySelector(".js-application-container").style.display = "none";
    document.querySelector(".btn-container").style.display = "block";
    document.querySelector("form").reset();
  }
}
