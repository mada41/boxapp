module ApplicationHelper
	def component_select
		'
			<optgroup label="Database">
	      <option value="postgres">Postgres</option>
	      <option value="mysql">MySQL</option>
	      <option value="mongo">MongoDB</option>
	    </optgroup>
	    <optgroup label="Other">
	      <option value="elasticsearch">Elasticsearch</option>
	      <option value="redis">Redis</option>
	    </optgroup>

	  '.html_safe
	end
end
