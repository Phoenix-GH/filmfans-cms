class CreateMovieCelebrityMappings < ActiveRecord::Migration
  def change
    create_table :movie_celebrity_mappings do |t|
      t.string :person_id, null: false
      t.string :source, null: false
      t.string :instagram_id
      t.string :name, null: false
      t.string :name_lower, null: false
      t.string :image_uri, null: false
    end

    add_index :movie_celebrity_mappings, [:person_id, :source], unique: true
    add_index :movie_celebrity_mappings, [:name_lower]

    MovieApiResultCache.where(api_type: 'CELEB_DETAIL').find_each(batch_size: 10) do |celeb|
      c = celeb.content

      m = MovieCelebrityMapping.find_by(person_id: c['personId'], source: 'GRACENOTE')

      if m.blank?
        MovieCelebrityMapping.create(
            {
                person_id: c['personId'],
                source: 'GRACENOTE',
                name: "#{c['name']['first']} #{c['name']['last']}",
                name_lower: "#{c['name']['first']} #{c['name']['last']}".downcase,
                image_uri: c['preferredImage']['uri'],
            })
      end
    end

  end
end
