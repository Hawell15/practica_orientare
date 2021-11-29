module HomeHelper
  def parse_data(path)
    if path[/(xlsx|xlx|ods)$/]
      file  = Roo::Spreadsheet.open(path)
      sheet = file.sheet(0)
      parse_excel(sheet)
    else
      file = File.read(path)
      html = Nokogiri::HTML(file)
      script = html.css('script').detect { |scr| scr.text.include?('var race') }.text
      json   = JSON.parse(script.split(/var \S+ = /).second.remove(';'))
      parse_json(json)
    end
  end

  def parse_json(json)
    competition_hash = {
      competition_name: json.dig('data', 'title'),
      date:             json.dig('data', 'start_datetime').to_date.as_json,
      location:         json.dig('data', 'location')
    }
    comp_id = add_competition(competition_hash).id

    json['groups'].each do |group|
      group_hash = {
        group_name:           group['name'],
        competition_id: comp_id
      }.compact
      group_id = add_group(group_hash).id

      json['persons'].select { |pers| pers['group_id'] == group['id'] }.each do |runner|
        club = json['organizations'].detect { |org| org['id'] == runner['organization_id'] }
        club_hash = {
          club_name: club['name'],
          representative: club['contact'],
          territory: club['region']
        }.compact

        runner_hash = {
          runner_name: runner['surname'],
          surname: runner['name'],
          dob:runner['birth_date'],
          gender: group['name'].first,
          club_id: add_club(club_hash).id
        }.compact

        category_id = convert_category(runner['qual'])
        new_runner  = add_runner(runner_hash, category_id)
        result      = json['results'].detect { |res| res['person_id'] == runner['id'] }
        next if result.nil? || result['place'].to_i < 1

        result_hash = {
          runner_id:   new_runner.id,
          place:       result['place'],
          time:        result['result_msec'] / 1000,
          group_id:    group_id,
          category_id: default_category.id
        }.compact
        add_result(result_hash)
      end
    end
  end

  def parse_excel(sheet)
    club_data = {
      club_name: sheet.cell(2, 'B'),
      territory: sheet.cell(2, 'C'),
      representative: sheet.cell(2, 'D'),
      email: sheet.cell(2, 'F'),
      phone: sheet.cell(2, 'H')
    }.compact

    club = add_club(club_data)

    (5..sheet.last_row).each do |index|
      next if sheet.cell(index, 'B').blank?

      runner_hash = {
        runner_name: sheet.cell(index, 'B'),
        surname: sheet.cell(index, 'C'),
        gender: sheet.cell(index, 'F'),
        dob: sheet.cell(index, 'D').to_date.as_json,
        club_id: club.id
      }.compact

      runner = add_runner(runner_hash)

      competition_hash = {
        comeptition_name: sheet.cell(index, 'I'),
        date: sheet.cell(index, 'H'),
        location: sheet.cell(index, 'L'),
        country: sheet.cell(index, 'M'),
        distance_type: sheet.cell(index, 'K'),
        group: sheet.cell(index, 'J')
      }.compact

      competition = add_competition(competition_hash)

      group_hash = {
        competition_id: competition.id,
        name: sheet.cell(index, 'J')
      }.compact

      group_id    = add_group(group_hash).id
      category_id = detect_category({ name: sheet.cell(index, 'G') }).id
      time        = sheet.cell(index, 'N') + 1 if sheet.cell(index, 'N')

      result_hash = {
        runner_id:    runner.id,
        category_id: category_id,
        place:       sheet.cell(index, 'O'),
        time:        time,
        group_id:    group_id,
      }.compact

      add_result(result_hash)
    end
  end

  def convert_category(category_id)
    case category_id
    when 9 then 1
    when 8 then 2
    when 7 then 3
    when 6 then 6
    when 5 then 5
    when 4 then 4
    when 3 then 9
    when 2 then 8
    when 1 then 7
    when 0 then 10
    end
  end
end
