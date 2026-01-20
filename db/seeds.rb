# Seeds create a tiny demo team for local development.
# Run: bin/rails db:seed

return unless Rails.env.development?

team = Team.find_or_create_by!(name: "Demo Team")

alice = team.team_users.find_or_create_by!(username: "alice") do |u|
  u.profile_pic_url = "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y"
end

bob = team.team_users.find_or_create_by!(username: "bob")

alice.status_updates.create!(team:, status: "Deep work") if alice.status_updates.empty?

bob.status_updates.create!(team:, status: "Out for lunch") if bob.status_updates.empty?

puts "Seeded team: #{team.name}"
puts "Team page: /teams/#{team.uuid}"
puts "Public key: #{team.public_key}"
puts "Secret key: #{team.secret_key} (shown once)"
