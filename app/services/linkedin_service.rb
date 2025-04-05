class LinkedInService < ApplicationService
  ## LinkedIn Voyager API Endpoints
  ENDPOINTS = {
    badges: '/memberBadges',
    certifications: '/certifications',
    contact_information: '/profileContactInfo',
    courses: '/courses',
    honors: '/honors',
    languages: '/languages',
    network_information: '/networkinfo',
    patents: '/patents',
    privacy_settings: '/privacySettings',
    profile: '/profileView',
    publications: '/publications',
    skills: '/skills',
    volunteer_causes: '/volunteerCauses',
    volunteer_experiences: '/volunteerExperiences'
  }.freeze

  ## Object / Entity Types
  TYPES = {
    company: 'com.linkedin.voyager.entities.shared.MiniCompany',
    volunteer_experience: 'com.linkedin.voyager.identity.profile.VolunteerExperience',
    school: 'com.linkedin.voyager.entities.shared.MiniSchool',
    certification: 'com.linkedin.voyager.identity.profile.Certification',
    course: 'com.linkedin.voyager.identity.profile.Course',
    education: 'com.linkedin.voyager.identity.profile.Education',
    honor: 'com.linkedin.voyager.identity.profile.Honor',
    publication: 'com.linkedin.voyager.identity.profile.Publication',
    skill: 'com.linkedin.voyager.identity.profile.Skill',
    volunteer_cause_view: 'com.linkedin.voyager.identity.profile.VolunteerCauseView',
    profile: 'com.linkedin.voyager.identity.profile.Profile'
  }.freeze

  ## Company API Base URI
  COMPANY_API_BASE_URI = 'https://www.linkedin.com/voyager/api/entities/companies/'.freeze

  ## Keys
  EXCLUDED_KEYS = %w[$type entityUrn backgroundImage picture trackingId objectUrn dashEntityUrn *inventors].freeze
  PROFILE_KEYS = %w[firstName lastName headline locationName geoCountryName geoLocationName industryName address student].freeze
  PUBLICATION_KEYS = %w[name description url publisher].freeze
  VOLUNTEER_EXPERIENCE_KEYS = %w[role companyName cause description].freeze
  CERTIFICATION_KEYS = %w[name authority licenseNumber url].freeze
  COMPANY_KEYS = %w[ companyType description industries websiteUrl specialties employeeCountRange ].freeze

  def initialize(username)
    @username = username
    @api_base_uri = "https://www.linkedin.com/voyager/api/identity/profiles/#{@username}"

    @headers = {
      "Accept": 'application/vnd.linkedin.normalized+json+2.1',
      "Accept-Encoding": 'gzip, deflate, br, zstd',
      "Accept-Language": 'en-US,en;q=0.9',
      "Referer": "https://www.linkedin.com/in/#{@username}/",
      "Referrer-Policy": 'strict-origin-when-cross-origin',
      "Sec-Fetch-Dest": 'empty',
      "Sec-Fetch-Mode": 'cors',
      "Sec-Fetch-Site": 'same-origin',
      "Sec-GPC": '1',
      "User-Agent": 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
      "X-Li-Lang": 'en_US',
      "X-Li-Page-Instance": 'urn:li:page:d_flagship3_profile_view_base;AAYyAPswqZnzIDHynrAK7g==',
      "X-Restli-Protocol-Version": '2.0.0',
      "Cookie": 'li_at=AQEDASxw-pUA9MHqAAABkVnCyRgAAAGWEKxfIlYARCm6YbFaytx-wVa2-b9zHhFXX2X9-lwZM4ODZDMVm2VN3mrd7Dfzh2vIBMYcubIXwpT29EM6G1w6nZlAsUQvHBviSrSvGLwc-Bd8HcuqCBq0Rm6c; JSESSIONID="ajax:4170723596360667143"',
      "Csrf-token": 'ajax:4170723596360667143'
    }
  end

  def call
    {
      profile: profile,
      companies: companies,
      skills: skills,
      interests: interests,
      schools: schools,
      courses: courses,
      honors: honors,
      certifications: certifications,
      patents: patents,
      publications: publications,
      volunteer_causes: volunteer_causes,
      volunteer_experiences: volunteer_experiences,
      contact_information: contact_information,
      followers_count: followers_count
    }
  end

  def fetch(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request.initialize_http_header(@headers)

    response = http.request(request)

    JSON.parse(response.body)
  end

  private

  def fetch_profile
    @profile ||= fetch("#{@api_base_uri}#{ENDPOINTS[:profile]}")
  end

  def fetch_company(company_id)
    fetch("#{COMPANY_API_BASE_URI}#{company_id}")
  end

  def fetch_contact_information
    @contact_information ||= fetch("#{@api_base_uri}#{ENDPOINTS[:contact_information]}")
  end

  def profile
    response = fetch_profile
    response['included'].select { |i| i['$type'] == TYPES[:profile] }&.last&.slice(*PROFILE_KEYS)
  end

  def companies
    response = fetch_profile
    response['included']
      .select { |i| i['$type'] == TYPES[:company] }
      .map do |c|
      company_id = c['objectUrn'].split(':').last
      fetch_company(company_id)
    end
      .map { |c| c['data'].slice(*COMPANY_KEYS).merge({ headquarters: c.dig('basicCompanyInfo', 'headquarters'), foundedDate: c.dig('foundedDate', 'year') }.transform_keys(&:to_s)) }
  end

  def skills
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:skills]}")
    response['included'].map { |s| s['name'] }
  end

  def badges
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:badges]}")
    response['data'].map { |key, value| value == true ? key : nil }.compact
  end

  def contact_information
    response = fetch_contact_information
    response['data'].except(*['interests', 'websites'].push(EXCLUDED_KEYS))
  end

  def interests
    response = fetch_contact_information
    response.dig('data', 'interests')&.map { |i| i.dig('interest', 'type') }
  end

  def followers_count
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:network_information]}")
    response.dig('data', 'followersCount')
  end

  def schools
    response = fetch_profile
    response['included'].select { |i| i['$type'] == TYPES[:school] }.map { |s| s['schoolName'] }
  end

  def honors
    response = fetch_profile
    response['included'].select { |i| i['$type'] == TYPES[:honor] }.map { |h| { title: h['title'], description: h['description'], issuer: h['issuer'], issue_date: "#{h.dig('issueDate', 'year')}-#{h.dig('issueDate', 'month')}" } }
  end

  def publications
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:publications]}")
    response['included'].select { |i| i['$type'] == TYPES[:publication] }.map { |p| p.slice(*PUBLICATION_KEYS).merge({ date: "#{p.dig('date', 'month')}-#{p.dig('date', 'day')}-#{p.dig('date', 'year')}" }.transform_keys(&:to_s)) }
  end

  def volunteer_causes
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:volunteer_causes]}")
    response.dig('data', 'elements')&.map { |c| c['causeName'] }
  end

  def volunteer_experiences
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:volunteer_experiences]}")
    response['included'].select { |i| i['$type'] == TYPES[:volunteer_experience] }.map { |p| p.slice(*VOLUNTEER_EXPERIENCE_KEYS) }
  end

  def certifications
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:certifications]}")
    response['included'].select { |i| i['$type'] == TYPES[:certification] }.map { |c| c.slice(*CERTIFICATION_KEYS) }
  end

  def courses
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:courses]}")
    response['included'].select { |i| i['$type'] == TYPES[:course] }.map { |c| c['name'] }
  end

  def patents
    response = fetch("#{@api_base_uri}#{ENDPOINTS[:patents]}")
    response['included'].select { |i| i['$type'] == TYPES[:patent] }.map { |p| p.except(*EXCLUDED_KEYS) }
  end
end
