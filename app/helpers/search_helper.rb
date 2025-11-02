require "amatch"
include Amatch

module SearchHelper
  def fuzzy_search_all(query, threshold: 0.6)
    query_down = query.downcase.strip
    words = query_down.split(/\s+/)

    models = [ BulletinPost, TeachingOffer, Project ]

    results = models.flat_map do |model|
      model.all.select do |record|
        title = record.title.to_s.downcase
        desc  = record.description.to_s.downcase

        # 1️⃣ Exact substring match
        exact_match = words.any? { |w| title.include?(w) || desc.include?(w) }

        # 2️⃣ Fuzzy token match
        fuzzy_match = words.any? do |word|
          matcher = Levenshtein.new(word)
          tokens = (title.split(/\W+/) + desc.split(/\W+/))
          tokens.any? { |token| matcher.similar(token) >= threshold }
        end

        exact_match || fuzzy_match
      end.map do |record|
        # Compute similarity score for ranking
        score = words.sum do |w|
          if record.title.downcase.include?(w) || record.description.downcase.include?(w)
            1.0
          else
            matcher = Levenshtein.new(w)
            tokens = (record.title.downcase.split(/\W+/) + record.description.downcase.split(/\W+/))
            tokens.map { |t| matcher.similar(t) }.max || 0
          end
        end

        { type: model.name, record:, score: }
      end
    end

    # Sort all results across models by score (descending)
    results.sort_by { |r| -r[:score] }
  end
end
