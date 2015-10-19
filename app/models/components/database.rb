class Components::Database < Component

  def get_db_url
    cmd = `dokku #{self.c_type}:info #{self.name}`
    cmd.gsub("\n", '').gsub('DSN:', '').strip
  end

  private

    def create_dokku_component
      `dokku #{self.c_type}:create #{self.name}`
    end

    def delete_dokku_component
      `yes #{self.name} | dokku #{self.c_type}:destroy #{self.name}`
    end
end