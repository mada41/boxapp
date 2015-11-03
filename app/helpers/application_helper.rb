module ApplicationHelper
	def component_select
		'
			<optgroup label="Database" data-max-options="2">
	      <option value="postgres">Postgres</option>
	    </optgroup>
	  '.html_safe
	end
end
