module SeoTitle
  # Leaves room for the " | Théorie musicale" suffix within meta-tags' 70 chars limit
  MAX_LENGTH = 51

  # Longest "base + suffix" fitting the limit, suffixes being ordered from the most to the least descriptive
  def self.fit(base, suffixes)
    (suffixes + ['']).map { |suffix| base + suffix }.find { |title| title.length <= MAX_LENGTH } || base
  end
end
