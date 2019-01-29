# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cup.create({capacity: 5.24, color: "purple", material: "flesh"})
Cup.create({capacity: 7.00, color: "teal", material: "ceramic"})
Cup.create({capacity: 4.77, color: "black", material: "black matter"})
Cup.create({capacity: 2.50, color: "green", material: "carbon fiber"})


# trevor = User.create({name: "Trevor", email: "TrevorHatesPuppies4@hotmail.com", password: "k1llPupz"})
# jackie = User.create({name: "Jackie", email: "ColorsArePretty@gmail.com", password: "r41nB0Wz"})

# Cup.create({capacity: 5.24, color: "purple", material: "flesh", user: trevor})
# Cup.create({capacity: 7.00, color: "teal", material: "ceramic", user: jackie})
# Cup.create({capacity: 4.77, color: "black", material: "black matter", user: trevor})
# Cup.create({capacity: 2.50, color: "green", material: "carbon fiber", user: jackie})