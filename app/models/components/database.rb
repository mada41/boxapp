class Components::Database < Component

  def get_db_url
    cmd = `dokku #{self.c_type}:info #{self.name}`
    cmd.gsub("\n", '').gsub('DSN:', '').strip
  end
end