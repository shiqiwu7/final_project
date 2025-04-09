# Create Admin User
admin = User.create!(
  name: "Admin",
  email: "admin@example.com",
  password: "passwordadmin",
  password_confirmation: "passwordadmin",
  role: "organizer"
)

# Create Player Users
player1 = User.create!(
  name: "John Doe",
  email: "player1@example.com",
  password: "password1",
  password_confirmation: "password1",
  role: "player"
)

player2 = User.create!(
  name: "Jane Smith",
  email: "player2@example.com",
  password: "password2",
  password_confirmation: "password2",
  role: "player"
)

player3 = User.create!(
  name: "Mike Johnson",
  email: "player3@example.com",
  password: "password3",
  password_confirmation: "password3",
  role: "player"
)

# Create Teams for Players
team1 = player1.player.owned_teams.create!(
  name: "The Champions",
  description: "A team that strives for excellence in every match."
)

team2 = player2.player.owned_teams.create!(
  name: "Victory Squad",
  description: "We play to win and have fun doing it."
)

team3 = player3.player.owned_teams.create!(
  name: "Dream Team",
  description: "A collective of talented athletes pushing the boundaries."
)

team4 = player1.player.owned_teams.create!(
  name: "Phoenix Rising",
  description: "Rising from the ashes to claim victory."
)

# Create Events
event1 = admin.organizer.events.create!(
  name: "Annual Championship",
  description: "The biggest sporting event of the year where teams compete for the prestigious trophy.",
  start_date: 2.months.from_now,
  end_date: 2.months.from_now + 3.days,
  location: "Central Stadium"
)

event2 = admin.organizer.events.create!(
  name: "Winter Tournament",
  description: "A friendly tournament to keep the competitive spirit alive during winter.",
  start_date: 3.weeks.from_now,
  end_date: 3.weeks.from_now + 2.days,
  location: "Indoor Sports Complex"
)

event3 = admin.organizer.events.create!(
  name: "Summer Cup",
  description: "Beat the heat with some hot competition in our annual summer event.",
  start_date: 2.days.ago,
  end_date: 1.day.ago,
  location: "Beachside Arena"
)

# Create Participations
Participation.create!(
  team: team1,
  event: event1,
  status: "approved" # Changed from "approved" to match the validation in the model
)

Participation.create!(
  team: team2,
  event: event1,
  status: "approved"
)

Participation.create!(
  team: team3,
  event: event1,
  status: "pending"
)

Participation.create!(
  team: team1,
  event: event2,
  status: "approved"
)

Participation.create!(
  team: team4,
  event: event2,
  status: "approved"
)

Participation.create!(
  team: team1,
  event: event3,
  status: "approved"
)

Participation.create!(
  team: team2,
  event: event3,
  status: "approved"
)

# Create Result for the past event
Result.create!(
  event: event3,
  winner_team: team1,
  score: "Team Champions 3 - Victory Squad 2"
)

puts "Seed data created successfully!"
