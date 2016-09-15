Sequel.migration do
  up do
    sql = <<-_SQL
      ALTER TABLE page_views
      MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    _SQL
    execute(sql.strip!)
  end

  down do

  end
end
