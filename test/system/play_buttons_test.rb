require "application_system_test_case"

class PlayButtonsTest < ApplicationSystemTestCase
  # The notes scheduled on the piano, which jazzity-audio.js records in window.jazzityAudioLog
  def played_notes
    evaluate_script("window.jazzityAudioLog.filter(e => e.type === 'note').map(e => e.midi)")
  end

  def listen
    execute_script("window.jazzityAudioLog = []")
  end

  test "plays a chord, and stops when clicked again" do
    visit "/tonalite/eb/accords/majeur-7"
    listen
    click_button "Écouter"

    assert_selector ".play-button[data-play=chord][aria-pressed=true]"
    assert_equal [63, 67, 70, 74], played_notes

    click_button "Écouter"
    assert_selector ".play-button[data-play=chord][aria-pressed=false]"
  end

  test "arpeggiates a chord, stopping the chord playing before" do
    visit "/tonalite/eb/accords/majeur-7"
    listen
    click_button "Écouter"
    assert_selector ".play-button[data-play=chord][aria-pressed=true]"
    listen
    click_button "Arpège"

    assert_selector ".play-button[data-play=chord][aria-pressed=false]"
    assert_selector ".play-button[data-play=arpeggio][aria-pressed=true]"
    # Scheduled a little ahead of the clock, so wait for the last note
    assert_selector ".play-button[data-play=arpeggio][aria-pressed=false]", wait: 10
    assert_equal [63, 67, 70, 74], played_notes
  end

  test "runs a mode up and back down" do
    visit "/gammes/majeure/modes/dorien"
    listen
    click_button "Écouter"

    # Scheduled a little ahead of the clock, so wait for the whole run
    assert_selector ".play-button[aria-pressed=false]", wait: 10
    assert_equal [62, 64, 65, 67, 69, 71, 72, 74, 72, 71, 69, 67, 65, 64, 62], played_notes
  end

  test "plays a progression, lighting up the sounding chord" do
    visit "/progressions/ii-v-i-majeur"
    listen
    uncheck "En boucle"
    click_button "Écouter en C"

    assert_selector "tr[data-play-key=c] .play-cell.is-playing", count: 1
    # Dm7 and G7 for a bar each, Cmaj7 for two, at 100 BPM
    assert_selector ".play-button[aria-pressed=false]", text: "Écouter en C", wait: 15
    assert_no_selector ".play-cell.is-playing"
    assert_equal [50, 60, 65, 69, 43, 62, 65, 71, 48, 64, 67, 71], played_notes
  end

  test "shows a progression as playing on both of its buttons" do
    visit "/progressions/ii-v-i-majeur"
    click_button "Écouter en C"
    assert_selector "tr[data-play-key=c] .play-button[aria-pressed=true]"

    find("tr[data-play-key=c] .play-button").click
    assert_no_selector ".play-button[aria-pressed=true]"
    assert_no_selector ".play-cell.is-playing"
  end
end
