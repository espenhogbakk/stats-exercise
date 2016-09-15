Sequel.migration do
  change do
    # We set the MySQL engine to MyISAM since that usually performs better than
    # InnoDB when doing mostly reads
    #
    # There is also 2 indexes. The combination of MyISAM and those indexes
    # make the inserting of the whole dataset a lot slower, but speed up the
    # reading of the data later on.
    create_table(:page_views, { engine: 'MyISAM' }) do
      primary_key :id
      String :url, null: false
      String :referrer, null: true
      DateTime :created_at, null: false
      String :hash, null: false

      index [:url, :created_at]
      index [:created_at]
    end
  end
end
