Sequel.migration do
  change do
    create_table(:page_views) do
      primary_key :id, :type=>"int(11)"
      column :url, "varchar(255)", :null=>false
      column :referrer, "varchar(255)"
      column :created_at, "datetime", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :hash, "varchar(255)", :null=>false
      
      index [:created_at]
      index [:url, :created_at]
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
  end
end
              Sequel.migration do
                change do
                  self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160912213110_create_page_views.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160912224043_add_db_level_hashing_to_page_view.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160913181829_add_timestamp_to_page_view.rb')"
                end
              end
