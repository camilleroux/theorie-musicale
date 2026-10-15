// Play buttons: plays the notes of a chord, mode, interval or note, or the
// chords of a progression, through Jazzity's electric piano
// (vendor/assets/javascripts/jazzity-audio.js).
//
//   <button class="play-button" data-play="chord" data-notes='["C/4","E/4","G/4"]'>
//
// `data-notes` are written as on the staff (VexFlow, octave of the letter).
// `data-play` is "chord" (struck together), "arpeggio" (one by one, held)
// or "scale" (up and back down). Clicking a playing button stops it.
//
//   <button class="play-button" data-play="sequence" data-steps='[{"notes":[38,60,65,69],"beats":4,"step":0}]'
//           data-highlight='[data-play-key="c"]' data-loop="progression-loop">
//
// A "sequence" plays its steps (MIDI notes) in time, again and again while
// the `data-loop` checkbox is ticked, lighting up the elements with the
// step's data-play-step or data-play-bar inside those `data-highlight` selects.
(function () {
  "use strict"

  // Eighth notes at this tempo for arpeggios and scales, beats for sequences.
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

  // Chords of a sequence, slightly spread like a pianist's hands
  function sequenceSteps(steps) {
    return steps.map((step) => ({ ...step, spread: 0.008 }))
  }

  function highlight(button, step) {
    document.querySelectorAll(".play-cell.is-playing").forEach((cell) => cell.classList.remove("is-playing"))
    if (!step || !button.dataset.highlight) return

    document.querySelectorAll(button.dataset.highlight).forEach((scope) => {
      scope.querySelectorAll(`[data-play-step="${step.step}"], [data-play-bar="${step.bar}"]`).forEach((cell) => cell.classList.add("is-playing"))
    })
  }

  // The buttons playing the same thing as a button (a progression in a key has two)
  function group(button) {
    if (!button.dataset.highlight) return [button]
    return [...document.querySelectorAll(".play-button")].filter((other) => other.dataset.highlight === button.dataset.highlight)
  }

  function press(buttons, player) {
    buttons.forEach((button) => {
      button.player = player
      button.setAttribute("aria-pressed", String(!!player))
    })
  }

  document.addEventListener("click", async (event) => {
    const button = event.target.closest(".play-button")
    if (!button) return

    const audio = window.JazzityAudio
    if (button.player) return button.player.stop()

    const kind = button.dataset.play
    const buttons = group(button)
    const loop = document.getElementById(button.dataset.loop)
    await audio.start()

    const player = {
      stop() {
        sequencer.stop()
        done()
      }
    }
    const done = () => {
      audio.release(player)
      press(buttons, null)
      highlight(button, null)
    }
    const sequencer = kind === "sequence"
      ? new audio.Sequencer(sequenceSteps(JSON.parse(button.dataset.steps)), {
        tempo: () => TEMPO,
        loop: () => !!loop?.checked,
        onStep: (step) => highlight(button, step),
        onEnd: done
      })
      : new audio.Sequencer(steps(kind, JSON.parse(button.dataset.notes).flat().map(midi).filter((note) => note !== null)), { tempo: () => TEMPO, onEnd: done })

    audio.claim(player)
    press(buttons, player)
    sequencer.start()
  })
})()
