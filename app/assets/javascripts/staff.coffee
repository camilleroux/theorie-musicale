renderStaffs = ->
  $(".staff canvas").remove() # avoid multiple rendering
  $(".staff").vexflow()

# Initial page load
document.addEventListener "DOMContentLoaded", renderStaffs

# Turbo navigation
document.addEventListener "turbo:load", renderStaffs