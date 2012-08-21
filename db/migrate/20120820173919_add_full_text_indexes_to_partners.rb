# -*- coding: undecided -*-
class AddFullTextIndexesToPartners < ActiveRecord::Migration
  def self.up
    if DB_ADAPTER == 'PostgreSQL'
      # Índice para utilizar búsqueda full text (por el momento sólo en español)
      execute "CREATE INDEX index_partners_on_name_and_lastname ON partners USING gin(to_tsvector('spanish', coalesce(name,'') || ' ' || coalesce(lastname,'')))"
    else
      add_index :partners, :name
      add_index :partners, :lastname
    end
  end

  def self.down
    if DB_ADAPTER == 'PostgreSQL'
      execute 'DROP INDEX index_partners_on_name_and_lastname'
    else
      remove_index :partners, :column => :name
      remove_index :partners, :column => :lastname
    end
  end

end
