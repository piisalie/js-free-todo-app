require 'nomadize/config'
require 'sql_capsule'
require_relative 'item'

class DB
  CONNECTION = Nomadize::Config.db

  def self.item_queries
    @device_queries ||= begin
                          capsule = SQLCapsule.wrap(Nomadize::Config.db)

                          capsule.register(:all,
                            "SELECT * FROM items;") { |item| Item.new(name: item['name'], id: item['id'], status: item['status']) }

                          capsule.register(:update_status,
                            "UPDATE items SET status = $1 WHERE id = $2 RETURNING id;",
                            :status, :id)

                          capsule.register(:new,
                            "INSERT INTO items (name) VALUES ($1) RETURNING id;",
                            :name)

                          capsule.register(:destroy,
                            "DELETE FROM items WHERE id = $1;",
                            :id)

                          capsule
                        end
  end
end
