Sequel.migration do
  up do
    # CONCAT_WS skips any NULL values, see details:
    # https://dev.mysql.com/doc/refman/5.7/en/string-functions.html#function_concat-ws
    sql = <<-_SQL
      CREATE TRIGGER make_hash
      BEFORE INSERT ON page_views
      FOR EACH ROW BEGIN
        set new.hash = md5(concat_ws(';', new.id, new.url, new.referrer, new.created_at));
      END;
    _SQL
    execute(sql.strip!)
  end

  down do
    execute "DROP TRIGGER IF EXISTS make_hash"
  end
end
