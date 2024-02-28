RSpec.describe CirroIOV2::Resources::Gig do
  let(:site) { 'http://api.cirro.io' }
  let(:id) { '1' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end

  describe '#find' do
    it 'finds and renders a gig' do
      stub_api = stub_request(:get, "#{site}/v2/gigs/#{id}")
                 .to_return(body: File.read('./spec/fixtures/gig/create.json'))

      gig = described_class.new(client).find(id)

      expect(stub_api).to have_been_made
      expect(gig.class).to eq(CirroIOV2::Responses::GigResponse)
      expect(gig.object).to eq('gig')
    end
  end

  describe '#create' do
    let(:params) do
      {
        "title": 'Favourite programming language?',
        "description": 'Description of gig ...',
        "url": 'http://heathcote.co/zina.gibson',
        "start_at": 1652285764,
        "end_at": 1653412329,
        "total_seats": 2,
        "invitation_mode": 'auto',
        "invitation_multiplier": 5,
        "invitation_frequency": 1,
        "filter_query": {
          "status": 'active',
          "segment": 'my_favorite_testers',
        },
        "sort_query": {
          "status": 1,
        },
        "tasks": [
          { "title": 'Ah, Wilderness!', "base_price": 300 },
        ],
        "notification_payload": {
          "project_title": 'Corporate Tax',
          "task_title": 'Add dataset',
          "task_type": 'Review',
        },
        "epam_options": {
          "extra_mile": true,
        },
        archive_at: 1653412329,
      }
    end

    it 'creates a gig' do
      stub_api = stub_request(:post, "#{site}/v2/gigs")
                 .to_return(body: File.read('./spec/fixtures/gig/create.json'))

      gig = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(gig.class).to eq(CirroIOV2::Responses::GigResponse)
      expect(gig.object).to eq('gig')
      expect(gig.title).to eq(params[:title])
      expect(gig.seats_min).to eq(params[:total_seats])
      expect(gig.seats_max).to be_nil
      expect(gig.archived_at).to be_nil
      expect(gig.invitation_multiplier).to eq(params[:invitation_multiplier])
      expect(gig.invitation_frequency).to eq(params[:invitation_frequency])
      expect(gig.sort_query).to eq(params[:sort_query])
      expect(gig.tasks.class).to eq(CirroIOV2::Responses::GigTaskListResponse)
      expect(gig.tasks.object).to eq('list')
      expect(gig.tasks.data.first.class).to eq(CirroIOV2::Responses::GigTaskResponse)
      expect(gig.tasks.data.first.id).to eq('1')
      expect(gig.tasks.data.first.object).to eq('gig_task')
      expect(gig.tasks.data.first.title).to eq(params[:tasks].first[:title])
      expect(gig.tasks.data.first.base_price).to eq(params[:tasks].first[:base_price])
      expect(gig.invitation_notification_topic.class).to eq(CirroIOV2::Responses::InvitationNotificationTopicResponse)
      expect(gig.invitation_notification_topic.name).to eq('new_gig_invitation')
    end
  end

  describe '#update' do
    let(:params) do
      {
        title: 'New Title',
        end_at: 420,
      }
    end

    it 'updates a gig' do
      stub_api = stub_request(:post, "#{site}/v2/gigs/#{id}")
                 .to_return(body: File.read('./spec/fixtures/gig/update.json'))

      gig = described_class.new(client).update(id, params)

      expect(stub_api).to have_been_made
      expect(gig.class).to eq(CirroIOV2::Responses::GigResponse)
      expect(gig.object).to eq('gig')
      expect(gig.title).to eq(params[:title])
      expect(gig.end_at).to eq(params[:end_at])
      expect(gig.invitation_notification_topic.class).to eq(CirroIOV2::Responses::InvitationNotificationTopicResponse)
      expect(gig.invitation_notification_topic.name).to eq('new_gig_invitation')
    end
  end

  describe '#archive' do
    let(:params) do
      { archived_at: 1653412330 }
    end

    it 'archives a gig' do
      stub_api = stub_request(:post, "#{site}/v2/gigs/#{id}/archive")
                 .to_return(body: File.read('./spec/fixtures/gig/archive.json'))

      gig = described_class.new(client).archive(id, params)

      expect(stub_api).to have_been_made
      expect(gig.class).to eq(CirroIOV2::Responses::GigResponse)
      expect(gig.object).to eq('gig')
      expect(gig.title).to eq('Favourite programming language?')
      expect(gig.seats_min).to eq(2)
      expect(gig.seats_max).to be_nil
      expect(gig.archived_at).to eq(params[:archived_at])
      expect(gig.tasks.class).to eq(CirroIOV2::Responses::GigTaskListResponse)
      expect(gig.tasks.object).to eq('list')
      expect(gig.tasks.data.first.class).to eq(CirroIOV2::Responses::GigTaskResponse)
      expect(gig.tasks.data.first.id).to eq('1')
      expect(gig.tasks.data.first.object).to eq('gig_task')
      expect(gig.tasks.data.first.title).to eq('Ah, Wilderness!')
      expect(gig.tasks.data.first.base_price).to eq(300)
    end
  end

  describe '#delete' do
    it 'deletes a gig' do
      stub_api = stub_request(:delete, "#{site}/v2/gigs/#{id}")
                 .to_return(body: File.read('./spec/fixtures/gig/delete.json'))

      deleted_gig = described_class.new(client).delete(id)

      expect(stub_api).to have_been_made
      expect(deleted_gig.class).to eq(CirroIOV2::Responses::GigDeleteResponse)
      expect(deleted_gig.id).to eq(id)
      expect(deleted_gig.object).to eq('gig')
      expect(deleted_gig.deleted).to eq(true)
    end
  end

  describe '#tasks' do
    let(:params) do
      {
        title: 'All Passion Spent',
        base_price: 400,
      }
    end

    it 'creates task for gig' do
      stub_api = stub_request(:post, "#{site}/v2/gigs/#{id}/tasks")
                 .to_return(body: File.read('./spec/fixtures/gig/tasks.json'))

      gig_task = described_class.new(client).tasks(id, params)

      expect(stub_api).to have_been_made
      expect(gig_task.class).to eq(CirroIOV2::Responses::GigTaskResponse)
      expect(gig_task.object).to eq('gig_task')
      expect(gig_task.title).to eq(params[:title])
      expect(gig_task.base_price).to eq(params[:base_price])
    end
  end

  describe '#update_task' do
    let(:task_id) { '1' }
    let(:params) do
      {
        title: 'New Title',
        base_price: 420,
      }
    end

    it 'creates task for gig' do
      stub_api = stub_request(:post, "#{site}/v2/gigs/#{id}/tasks/#{task_id}")
                 .to_return(body: File.read('./spec/fixtures/gig/update_task.json'))

      gig_task = described_class.new(client).update_task(id, task_id, params)

      expect(stub_api).to have_been_made
      expect(gig_task.class).to eq(CirroIOV2::Responses::GigTaskResponse)
      expect(gig_task.object).to eq('gig_task')
      expect(gig_task.title).to eq(params[:title])
      expect(gig_task.base_price).to eq(params[:base_price])
    end
  end

  describe '#invite' do
    context 'when invite single user' do
      let(:params) do
        { user_id: 20 }
      end

      it 'creates gig invitation for the user' do
        stub_api = stub_request(:post, "#{site}/v2/gigs/#{id}/invite")
                   .to_return(body: File.read('./spec/fixtures/gig/invite_single.json'))

        gig_invitation = described_class.new(client).invite(id, params)

        expect(stub_api).to have_been_made
        expect(gig_invitation.class).to eq(CirroIOV2::Responses::GigInvitationResponse)
        expect(gig_invitation.object).to eq('gig_invitation')
        expect(gig_invitation.gig_id).to eq('10')
        expect(gig_invitation.user_id).to eq('20')
      end
    end

    context 'when invite multiple users' do
      let(:params) do
        {
          users: [{ id: 20 }, { id: 14 }],
        }
      end

      it 'creates gig invitation for the user' do
        stub_api = stub_request(:post, "#{site}/v2/gigs/#{id}/invite")
                   .to_return(body: File.read('./spec/fixtures/gig/invite_multi.json'))

        gig_invitations = described_class.new(client).invite(id, params)

        expect(stub_api).to have_been_made
        expect(gig_invitations.class).to eq(CirroIOV2::Responses::GigInvitationListResponse)
        expect(gig_invitations.object).to eq('list')
        expect(gig_invitations.data.pluck(:user_id)).to match_array(['20', '14'])
      end
    end
  end
end
