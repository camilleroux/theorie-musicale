module ChordsHelper
  # "En jazz, … le II-V-I majeur : Dm7 – G7 – Cmaj7 en do majeur.", the progression linked in that key
  def chord_role_sentence(role)
    return typo_fr(role.text) unless role.progression

    tonalite = role.tonic.to_param if !role.tonic.main? && Key.primaries.include?(role.tonic)
    safe_join([typo_fr("#{role.text} "), link_to(role.progression.short_name, progression_path(role.progression, tonalite: tonalite)),
               typo_fr(" : #{role.chords} en #{role.tonality}.")])
  end
end
