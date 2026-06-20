// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
// jqueryの読み込み
import $ from "jquery";

document.addEventListener("turbo:load", () => {
  $(".js-application-btn").on("click", () => {
    $(".js-application-container").css("display", "block");
    $(".btn-container").css("display", "none");
  });

  $(".js-cancel-btn").on("click", () => {
    $(".js-application-container").css("display", "none");
    $(".btn-container").css("display", "block");
  });
});
