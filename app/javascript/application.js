// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import $ from "jquery"

$(document).on("turbo:load",(event) => {
  $("#notice").addClass("hidden");
})
