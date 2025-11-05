require "rails_helper"

RSpec.describe SearchHelper, type: :helper do
  # Dummy data models assumed to exist in your app
  let!(:post1) { create(:bulletin_post, title: "Learn Ruby on Rails", description: "A complete guide to Rails development") }
  let!(:post2) { create(:bulletin_post, title: "Python Programming", description: "Learn to code in Python") }

  let!(:offer1) { create(:teaching_offer, title: "Advanced Distributed Systems", description: "Cloud and scalability topics") }
  let!(:offer2) { create(:teaching_offer, title: "Intro to Databases", description: "SQL basics and practice") }

  let!(:project1) { create(:project, title: "Distributed File System", description: "Fault tolerance and replication") }
  let!(:project2) { create(:project, title: "Web Crawler", description: "Scraping and indexing websites") }

  describe "#fuzzy_search_all" do
    context "when an exact word matches the title or description" do
      it "returns results including matching records" do
        results = helper.fuzzy_search_all("Rails")
        titles = results.map { |r| r[:record].title }

        expect(titles).to include("Learn Ruby on Rails")
        expect(results.first[:type]).to eq("BulletinPost")
      end
    end

    context "when searching across multiple models" do
      it "returns results from all searchable models" do
        results = helper.fuzzy_search_all("Distributed")
        types = results.map { |r| r[:type] }

        expect(types).to include("TeachingOffer", "Project")
        expect(results.map { |r| r[:record].title }).to include("Distributed File System")
      end
    end

    context "when using fuzzy matching (Levenshtein similarity)" do
      it "finds near matches even with small typos" do
        # 'Rubby' is a fuzzy misspelling of 'Ruby'
        results = helper.fuzzy_search_all("Rubby", threshold: 0.6)
        titles = results.map { |r| r[:record].title }

        expect(titles).to include("Learn Ruby on Rails")
      end

      it "does not match irrelevant words" do
        results = helper.fuzzy_search_all("Quantum", threshold: 0.8)
        expect(results).to be_empty
      end
    end

    context "when ranking results" do
      it "sorts higher scoring results first" do
        results = helper.fuzzy_search_all("Distributed")
        scores = results.map { |r| r[:score] }

        expect(scores).to eq(scores.sort.reverse) # descending order
      end
    end

    context "when multiple words are given" do
      it "matches records that contain any of the words" do
        results = helper.fuzzy_search_all("Python Ruby")
        titles = results.map { |r| r[:record].title }

        expect(titles).to include("Learn Ruby on Rails", "Python Programming")
      end
    end

    context "when query is empty or whitespace" do
      it "returns an empty array" do
        expect(helper.fuzzy_search_all("   ")).to be_empty
      end
    end
  end
end
