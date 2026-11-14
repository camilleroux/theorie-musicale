module EarTrainingHelper
  def ear_training_faq
    [
      Faq::Item.new("Comment reconnaître un intervalle à l'oreille ?", "En l'associant au début d'un morceau connu : la tierce majeure montante est le début de When the Saints Go Marching In, la quarte juste celui de All the Things You Are, la septième mineure celui de Somewhere. On compare ensuite chaque intervalle entendu avec ces repères."),
      Faq::Item.new("Quel standard de jazz commence par un triton ?", "Maria, de Leonard Bernstein (West Side Story), commence par un triton montant. En descendant, c'est le cas de Blue Seven, de Sonny Rollins."),
      Faq::Item.new("Quel standard commence par une octave ?", "Over the Rainbow, de Harold Arlen, commence par une octave montante ; Willow Weep for Me, d'Ann Ronell, par une octave descendante."),
      Faq::Item.new("Pourquoi travailler les intervalles quand on joue du jazz ?", "Reconnaître les intervalles permet de relever des thèmes et des solos à l'oreille, d'entendre la couleur d'un accord (tierce majeure ou mineure, septième) et de jouer ce que l'on entend dans sa tête en improvisation.")
    ]
  end
end
