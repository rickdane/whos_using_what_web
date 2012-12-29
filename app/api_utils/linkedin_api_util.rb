module LinkedinApiUtil

  @@base_url = "http://api.linkedin.com/v1/"

  def people_search linkedin_api_client, company_ids, title, location

    location = location.gsub(/\s+/, "+")

    base_url_tmp = @@base_url.clone

    company_id_str = ""
    i = 1
    company_ids.each do |company_id|
      delim = ""
      if i != 1
        delim = ","
      end
      company_id_str = company_id_str << delim << company_id
      i += i
    end

    url = base_url_tmp <<
        "people-search:(people:(id,first-name,last-name,public-profile-url,picture-url,headline,positions:(is-current,company:(id))))" <<
        "?facets=location,current-company" <<
        "&facet=location," << location <<
        "&facet=current-company," << company_id_str
        "&current-title=" << title

    linkedin_api_client.json_api_call_helper url, {}, true

  end

end