renderStaffs = ->
  $(".staff canvas").remove() # avoid multiple rendering
  $(".staff").vexflow()

# Initial page load (when DOM is ready)
if document.readyState is 'loading'
  document.addEventListener "DOMContentLoaded", renderStaffs
else
  # DOM is already ready
  renderStaffs()

# Turbo navigation
document.addEventListener "turbo:load", renderStaffs
document.addEventListener "turbo:frame-load", renderStaffs