class Stamp < ApplicationRecord
    has_many :taggings
    has_many :taggings, :dependent => :destroy
    has_many :tags, through: :taggings

    def tag_list
        self.tags.collect do |tag|
            tag.name
        end.join(", ")
    end

    def tag_list=(tags_string)
        tag_names = tags_string.split(" ").collect{|s| s.strip.downcase}.uniq
        new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
        self.tags = new_or_found_tags
    end

    # implement something like this: https://stackoverflow.com/questions/39691497/search-query-multiple-column-with-or-and-and-to-apply-filter
    def self.search(search)
        all = Stamp.joins(:tags)
        all = all.where('stamps.name LIKE :search
        OR colour LIKE :search
        OR place_of_printing LIKE :search
        OR artist LIKE :search OR currency LIKE :search
        OR tags.name LIKE :search', 
        search: "%#{search}%").order(:release_date)
    end

end

