document.addEventListener "turbolinks:load", ->
  $(".staff canvas").remove(); #avoid multiple rendering
  $(".staff").vexflow()