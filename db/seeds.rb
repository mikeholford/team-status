# Seeds create a tiny demo team for local development.
# Run: bin/rails db:seed

return unless Rails.env.development?

require "active_support/testing/time_helpers"
extend ActiveSupport::Testing::TimeHelpers

team = Team.find_or_create_by!(name: "Demo Team")

users = {
  "alice" => "https://api.dicebear.com/7.x/lorelei/png?seed=alice",
  "bob" => "https://api.dicebear.com/7.x/lorelei/png?seed=bob",
  "charlie" => "https://api.dicebear.com/7.x/lorelei/png?seed=charlie",
  "dana" => "https://api.dicebear.com/7.x/lorelei/png?seed=dana"
}

team_users = users.map do |username, avatar_url|
  team.team_users.find_or_create_by!(username:).tap do |u|
    u.update!(profile_pic_url: avatar_url) if u.profile_pic_url != avatar_url
  end
end

team_users.each { |u| u.status_updates.delete_all }

# We want expired statuses to exist while still enforcing the "expires_at must be in the future"
# validation. So we create updates while time-traveling.
now = Time.current

status_bank = [
  "Deep work",
  "Reviewing PRs",
  "In meetings",
  "Heads down",
  "Lunch",
  "Coffee break",
  "Writing docs",
  "Fixing bugs",
  "Pairing",
  "Planning"
]

history = {
  "alice" => [
    { at: now - 2.days, status: "Planning", expires_in: nil },
    { at: now - 1.day - 3.hours, status: "Writing docs", expires_in: 2.hours },
    { at: now - 1.day - 20.minutes, status: "Deep work", expires_in: nil },
    { at: now - 6.hours, status: "Reviewing PRs", expires_in: 90.minutes },
    { at: now - 2.hours, status: "Heads down", expires_in: 30.minutes },
    { at: now - 10.minutes, status: "Deep work", expires_in: nil }
  ],
  "bob" => [
    { at: now - 3.days, status: "Fixing bugs", expires_in: nil },
    { at: now - 1.day - 1.hour, status: "Coffee break", expires_in: 15.minutes },
    { at: now - 1.day, status: "Heads down", expires_in: 45.minutes },
    { at: now - 3.hours, status: "Pairing", expires_in: nil },
    { at: now - 1.hour, status: "Lunch", expires_in: 30.minutes },
    { at: now - 5.minutes, status: "Out for lunch", expires_in: 45.minutes }
  ],
  "charlie" => [
    { at: now - 2.days - 4.hours, status: "Planning", expires_in: nil },
    { at: now - 2.days, status: "Heads down on PRs", expires_in: 30.minutes },
    { at: now - 1.day - 2.hours, status: "In meetings", expires_in: 1.hour },
    { at: now - 8.hours, status: "Deep work", expires_in: nil },
    { at: now - 2.hours, status: "Heads down on PRs", expires_in: 30.minutes }
  ],
  "dana" => []
}

# Add extra filler history so the list feels real.
team_users.each do |user|
  entries = history.fetch(user.username)

  18.times do |i|
    at = now - (i + 1).hours - rand(5..55).minutes
    entries << {
      at: at,
      status: status_bank.sample,
      expires_in: ([nil, 30.minutes, 1.hour, 2.hours].sample)
    }
  end

  entries.sort_by! { |e| e.fetch(:at) }
end

team_users.each do |user|
  history.fetch(user.username).each do |entry|
    travel_to(entry.fetch(:at)) do
      user.status_updates.create!(
        team:,
        status: entry.fetch(:status),
        expires_at: entry.fetch(:expires_in)&.from_now
      )
    end
  end
end

puts "Seeded team: #{team.name}"
puts "Team page: /teams/#{team.uuid}"
puts "Public key: #{team.public_key}"
puts "Secret key: #{team.secret_key} (shown once)"
