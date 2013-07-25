ThinkingSphinx::Index.define :document, with: :active_record, delta: true, sql_range_step: 999999999, group_concat_max_len: 16384 do

  #~ How can I optmise this index so that I can have facets and indexes
  #~ on each association without it taking forever to run?
  #~ Having more than 3 indexes at any one time, means rake ts:index doesn't finish running.

  #~ has countries(:id), as: :country_ids
  has images(:id), as: :image_ids, facet: true
  has subscribers(:id), as: :subscriber_ids, facet: true
  #~ has tags(:id), as: :tag_ids, facet: true
  #~ has videos(:id), as: :video_ids, facet: true

  #~ indexes countries.name, as: :countries
  indexes images.title, as: :images
  indexes subscribers.title, as: :subscribers
  #~ indexes tags.name, as: :tags
  #~ indexes videos.title, as: :videos

  has updated_at

end
