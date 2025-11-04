require "amatch"
include Amatch

class BulletinPost < ApplicationRecord
    belongs_to :author, class_name: "User"

  # def self.fuzzy_search(query, threshold: 0.6)
  #     query_down = query.downcase.strip
  #     words = query_down.split(/\s+/)

  #     all.select do |post|
  #     title = post.title.to_s.downcase
  #     desc  = post.description.to_s.downcase

  #     exact_match = words.any? { |w| title.include?(w) || desc.include?(w) }

  #     fuzzy_match = words.any? do |word|
  #         matcher = Levenshtein.new(word)
  #         title_tokens = title.split(/\W+/)
  #         desc_tokens  = desc.split(/\W+/)

  #         (title_tokens + desc_tokens).any? { |token| matcher.similar(token) >= threshold }
  #     end

  #     exact_match || fuzzy_match
  #     end.sort_by do |post|
  #     title = post.title.to_s.downcase
  #     desc  = post.description.to_s.downcase

  #     words.map do |w|
  #         if title.include?(w) || desc.include?(w)
  #         1.0
  #         else
  #         matcher = Levenshtein.new(w)
  #         tokens = (title.split(/\W+/) + desc.split(/\W+/))
  #         tokens.map { |t| matcher.similar(t) }.max || 0
  #         end
  #     end.sum * -1
  #     end
  # end
end
