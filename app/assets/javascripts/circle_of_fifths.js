// Cycle des quintes: shows the panel of the chosen key only. Without JavaScript every panel stays visible,
// and wedges are plain anchor links to them.
(function () {
  "use strict"

  function select(anchor, panels, wedges) {
    if (!panels.some((panel) => panel.dataset.circlePanel === anchor)) anchor = panels[0].dataset.circlePanel
    panels.forEach((panel) => { panel.hidden = panel.dataset.circlePanel !== anchor })
    wedges.forEach((wedge) => {
      const selected = wedge.dataset.circleKey === anchor
      wedge.classList.toggle("is-selected", selected)
      wedge.setAttribute("aria-current", selected ? "true" : "false")
    })
  }

  document.addEventListener("DOMContentLoaded", () => {
    const circle = document.querySelector(".circle")
    if (!circle) return

    const panels = Array.from(document.querySelectorAll("[data-circle-panel]"))
    const wedges = Array.from(circle.querySelectorAll(".circle__wedge"))
    select(location.hash.slice(1), panels, wedges)

    document.addEventListener("click", (event) => {
      const link = event.target.closest("[data-circle-key]")
      if (!link) return
      event.preventDefault()
      select(link.dataset.circleKey, panels, wedges)
      history.replaceState(null, "", "#" + link.dataset.circleKey)
      // Below the circle (phones, key table), bring the panel into view
      const panel = document.getElementById(link.dataset.circleKey)
      if (panel.getBoundingClientRect().top < 0 || panel.getBoundingClientRect().top > window.innerHeight * 0.6) {
        panel.scrollIntoView({ behavior: "smooth", block: "start" })
      }
    })
  })
})()
