# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(name: 'Mohan', email: 'setup@appfolio.com',
                   password: 'Test@123', password_confirmation: 'Test@123')

Image.create(
  [
    { title: 'Image 1',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6601.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 2',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6602.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 3',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6603.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 4',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6604.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 5',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6625.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 6',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6621.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 7',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6623.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 8',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6608.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 9',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6609.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 10', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6624.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 11', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6611.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 12', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6612.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 13', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6613.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 14', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6614.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 15', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6615.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 16', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6616.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 17', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6621.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 18', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6618.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 19', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6619.jpg',
      tag_list: 'Awesome', user: user },
    { title: 'Image 20', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6620.jpg',
      tag_list: 'Awesome', user: user }
  ]
)
