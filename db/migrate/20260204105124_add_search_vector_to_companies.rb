class AddSearchVectorToCompanies < ActiveRecord::Migration[7.1]
  def up
    enable_extension "pg_trgm"

    # Add the tsvector column
    add_column :companies, :search_vector, :tsvector

    # GIN index on the search_vector for fast full-text queries
    add_index :companies, :search_vector, using: :gin, name: "index_companies_on_search_vector"

    # Trigram GIN index on company_name for fuzzy matching
    execute <<-SQL
      CREATE INDEX index_companies_on_company_name_trgm
      ON companies USING gin (company_name gin_trgm_ops);
    SQL

    # Populate search_vector for all existing rows with weighted fields
    execute <<-SQL
      UPDATE companies SET search_vector =
        setweight(to_tsvector('english', coalesce(company_name, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(sector, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(sub_sector, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(
          CASE
            WHEN key_tags IS NOT NULL AND jsonb_typeof(key_tags) = 'array'
            THEN (SELECT string_agg(elem::text, ' ') FROM jsonb_array_elements_text(key_tags) AS elem)
            ELSE ''
          END, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(description, '')), 'C') ||
        setweight(to_tsvector('english', coalesce(popup_bio, '')), 'C') ||
        setweight(to_tsvector('english', coalesce(city, '')), 'D') ||
        setweight(to_tsvector('english', coalesce(owner, '')), 'D');
    SQL

    # Create trigger function to auto-update search_vector on INSERT/UPDATE
    execute <<-SQL
      CREATE FUNCTION companies_search_vector_update() RETURNS trigger AS $$
      BEGIN
        NEW.search_vector :=
          setweight(to_tsvector('english', coalesce(NEW.company_name, '')), 'A') ||
          setweight(to_tsvector('english', coalesce(NEW.sector, '')), 'B') ||
          setweight(to_tsvector('english', coalesce(NEW.sub_sector, '')), 'B') ||
          setweight(to_tsvector('english', coalesce(
            CASE
              WHEN NEW.key_tags IS NOT NULL AND jsonb_typeof(NEW.key_tags) = 'array'
              THEN (SELECT string_agg(elem::text, ' ') FROM jsonb_array_elements_text(NEW.key_tags) AS elem)
              ELSE ''
            END, '')), 'B') ||
          setweight(to_tsvector('english', coalesce(NEW.description, '')), 'C') ||
          setweight(to_tsvector('english', coalesce(NEW.popup_bio, '')), 'C') ||
          setweight(to_tsvector('english', coalesce(NEW.city, '')), 'D') ||
          setweight(to_tsvector('english', coalesce(NEW.owner, '')), 'D');
        RETURN NEW;
      END
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER companies_search_vector_trigger
      BEFORE INSERT OR UPDATE OF company_name, sector, sub_sector, key_tags, description, popup_bio, city, owner
      ON companies
      FOR EACH ROW
      EXECUTE FUNCTION companies_search_vector_update();
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS companies_search_vector_trigger ON companies;"
    execute "DROP FUNCTION IF EXISTS companies_search_vector_update();"
    execute "DROP INDEX IF EXISTS index_companies_on_company_name_trgm;"
    remove_column :companies, :search_vector
  end
end
