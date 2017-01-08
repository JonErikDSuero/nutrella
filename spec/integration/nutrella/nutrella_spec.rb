RSpec.describe "Nutrella" do
  let(:board_name) { "My Board" }
  let(:url) { "board_url" }
  let(:board) { instance_double(Trello::Board, id: "id", name: board_name, url: url) }

  it "creates initial configuration file" do
    create_command do |subject|
      expect { subject.run }.to output(/you don't have a config file/).to_stderr
        .and(raise_error(SystemExit))
      expect(subject).to have_configuration(Nutrella::Configuration::INITIAL_CONFIGURATION)
    end
  end

  it "looks up an existing task board" do
    create_command do |subject|
      create_sample(subject.configuration_filename)
      trello_search(board_name, search_result: [board])

      expect(subject).to receive(:system).with("open #{url}")

      subject.run
    end
  end

  it "creates a task board" do
    create_command do |subject|
      create_sample(subject.configuration_filename)
      trello_search(board_name, search_result: [])

      expect(Nutrella::TrelloWrapper).to receive(:create_board)
        .with(name: board_name, organization_id: "developer_organization")
        .and_return(board)

      expect(Nutrella::TrelloWrapper).to receive(:set_board_visible_to_organization)
        .with(board.id)

      expect(subject).to receive(:system).with("open #{url}")

      subject.run
    end
  end

  def create_command
    Dir.mktmpdir { |home_dir| yield Nutrella::Command.new(home_dir, board_name) }
  end

  def trello_search(board_name, search_result:)
    allow(Nutrella::TrelloWrapper).to receive(:search_boards)
      .with(board_name)
      .and_return(search_result)
  end

  def create_sample(configuration_filename)
    File.write(configuration_filename, <<-SAMPLE.strip_heredoc)
        # Trello Developer API Keys
        key: developer_key
        secret: developer_secret
        token: developer_token

        # Optional Configuration
        organization: developer_organization
    SAMPLE
  end

  RSpec::Matchers.define :have_configuration do |expected_configuration|
    match do |command|
      expect(File.exist?(command.configuration_filename)).to eq(true)
      expect(File.read(command.configuration_filename)).to eq(expected_configuration)
    end
  end
end
