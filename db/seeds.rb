# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def random_likable
	@likable_indices.pop
end

def random_likable_reset!(n)
	@likable_indices = (0...n).to_a.shuffle
end

=begin

def assign_avatar!(user, name)
	filename = "#{name}.jpg"
	path = Rails.root.join("app/assents/images/Seed Avatars", filename)
	File.open(path) do |io|
		user.avatar.attach(io: io, filename: filename)
	end
end

=end

def user_params(name)
	{
		name: name,
		email: Faker::Internet.email,
		password: ENV['SEED_USER_PASSWORD'],
		education: Faker::University.name,
		location: Faker::Address.city,
		occupation: Faker::Job.title,
		birthday: Faker::Date.birthday(min_age: 18, max_age: 65)
	} 
end

@user = []

ActiveRecord::Base.transaction do
	Friendship.destroy_all
	FriendRequest.destroy_all
	Like.destroy_all
	Comment.destroy_all
	Post.destroy_all
	User.destroy_all

=begin
	I use this because my system is old and don't suport the new sql way  
	
	ActiveRecord::Base.connection.tables.each do |t|
		ActiveRecord::Base.connection.reset_pk_sequence!('t')
	end

=end

	ActiveRecord::Base.connection.tables do |t|
		result = ActiveRecord::Base.connection.execute("SELECT id FROM #{t} ORDER BY id DESC LIMIT 1") rescue ( puts "Warning: not procesing table #{t}. Id is missing?" ; next )
		ai_val = result.any? ? result.first['id'].to_i + 1 : 1
		puts "Resetting auto increment ID for #{t} to #{ai_val}"
		ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{t}_id_seq RESTART WITH #{ai_val}")
	end

	50.times do |i|
		first_name = i <= 32 ? Faker::Name.female_first_name : Faker::Name.male_first_name
		name = "#{first_name} #{Faker::Name.last_name}"
		@user << User.create!(user_params(name))
	end
	
	sample_user = User.create!(
    name: 'Odin',
    email: 'odin@example.com',
    password: 'password',
    education: 'Mead of Poetry',
    location: 'Iceland',
    occupation: 'God of Knowledge',
    website: 'www.theodinproject.com',
    birthday: '1/12/0040'
  )
  @users << sample_user

	# create posts
	posts = []
	100.times do |i|
		date = Faker::Date.between(from: 2.years.ago, to: Date.today)
		body = case i
		when 0..36 then Faker::GreekPhilosophers.quote
		when 37..72 then Faker::Quotes::Shakespeare.hamlet_quote
		when 73..108 then Faker::Quotes::Shakespeare.as_you_like_it_quote
		when 109..144 then Faker::Quotes::Shakespeare.king_richard_iii_quote
		else Faker::Quotes::Shakespeare.romeo_and_juliet_quote	
		end

	posts << Post.create!(
		body: body,
		author: @users[rand(@users.length)],
		created_at: date,
		updated_at: date
		)
	end

	# extra posts for users who will get photos (index in @users[] is their ID - 1)
	[0, 6, 10, 21, 23, 28, 34, 36, 38, 44, 54, 60].each do |index|
		10.times do
			date = Faker::Date.between(from: 2.years.ago, to: Date.today)
			posts << Post.create!(
				body: Faker::Quote.famous_last_words,
				author: @users[index],
				created_at: date,
				updated_at: date
				)
		end
	end

	# create comments
	comments = []
	posts.each do |post|
		rand(5).times do
			user = @users[rand(@users.length)]
			date = Faker::Date.between(from: post.created_at, to: Date.today)
			body = Faker::Quote.jack_handey
			comments << Comment.create!(
				commentable: post,
				author: user,
				body: body,
				created_at: date,
				updated_at: date
				)
		end
	end

	# create nested commnets
	nested_comments = []
	comments.each do |comment|
		rand(4).times do
			user = @user[rand(@users.length)]
			date = Faker::Date.between(from: comment.created_at, to: Date.today)
			body = Faker::Movies::HitchhikerGuideToTheGalaxy.marvin_quote
			nested_comments << Comment.create!(
				commentable: comment,
				author: user,
				body: body,
				created_at: date,
				updated_at: date
				)
		end
	end

	# create likes
	@users.length.times do |i|
		random_likable_reset!(posts.length)
		rand(posts.length / 7).times { Like.create!(likable: posts[random_likable], user: @user[i]) }

		random_likable_reset!(comments.length)
		rand(comments.length / 12).times { Like.create!(likable: comments[random_likable], user: @user[i]) }

		random_likable_reset!(nested_comments.length)
		rand(nested_comments.length / 24).times { Like.create!(likable: nested_comments[random_likable], user: @user[i]) }
	end

	# create friend request for Odin
	sample_user.no_contacts.take(20).each_with_index do |user, i|
		if i < 13
			FriendRequest.create!(requester: user, recipient: sample_user)
		else
			FriendRequest.create!(requester: sample_user, recipient: user)	
		end
	end

=begin
	# set seed avatars
	@users.each_with_index do |user, index|
		assign_avatar!(user, index)
	end
=end

end
