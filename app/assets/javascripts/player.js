// Play buttons: plays the notes of a chord, mode, interval or note through
// Jazzity's electric piano (vendor/assets/javascripts/jazzity-audio.js).
//
//   <button class="play-button" data-play="chord" data-notes='["C/4","E/4","G/4"]'>
//
// `data-notes` are written as on the staff (VexFlow, octave of the letter).
// `data-play` is "chord" (struck together), "arpeggio" (one by one, held)
// or "scale" (up and back down). Clicking a playing button stops it.
(function () {
  "use strict"

  // Eighth notes at this tempo for arpeggios and scales.
  const TEMPO = 100
  const LETTERS = { C: 0, D: 2, E: 4, F: 5, G: 7, A: 9, B: 11 }

  // "Eb/4" -> 63, "Cb/5" -> 71 (B4), "B#/3" -> 60 (C4)
  function midi(note) {
    const match = /^([A-G])(#{0,2}|b{0,2})\/(-?\d+)$/.exec(note)
    if (!match) return null
    const [, letter, accidental, octave] = match
    const shift = accidental.startsWith("#") ? accidental.length : -accidental.length
    return (Number(octave) + 1) * 12 + LETTERS[letter] + shift
  }

  function steps(kind, notes) {
    switch (kind) {
      case "arpeggio":
        return notes.map((note, i) => ({ notes: [note], beats: i === notes.length - 1 ? 3 : 0.5, hold: (notes.length - 1 - i) * 0.5 + 3 }))
      case "scale": {
        const top = notes[0] + 12
        const up = notes[notes.length - 1] === top ? notes : [...notes, top]
        const run = [...up, ...up.slice(0, -1).reverse()]
        return run.map((note, i) => ({ notes: [note], beats: i === run.length - 1 ? 2 : 0.5, hold: i === run.length - 1 ? 2 : 0.55 }))
      }
      default:
        return [{ notes, beats: 4, hold: 4, spread: 0.008 }]
    }
  }

  function press(button, pressed) {
    button.setAttribute("aria-pressed", String(pressed))
  }

  document.addEventListener("click", async (event) => {
    const button = event.target.closest(".play-button")
    if (!button) return

    const audio = window.JazzityAudio
    if (button.player) return button.player.stop()

    const notes = JSON.parse(button.dataset.notes).flat().map(midi).filter((note) => note !== null)
    await audio.start()

    const player = {
      stop() {
        sequencer.stop()
        done()
      }
    }
    const done = () => {
      audio.release(player)
      button.player = null
      press(button, false)
    }
    const sequencer = new audio.Sequencer(steps(button.dataset.play, notes), { tempo: () => TEMPO, onEnd: done })

    audio.claim(player)
    button.player = player
    press(button, true)
    sequencer.start()
  })
})()
