class AddMagazinesFromDropboxToDb
  def call
    ActiveRecord::Base.transaction do
      add_blue_inc_magazines
      add_heart_media_magazines
      add_tree_dance_magazines
    end
  end

  private
  def add_blue_inc_magazines
    puts 'Create Blu Inc Media Magazines'
    channel = Channel.find_by!(name: 'Blu Inc Media')
    @magazine1 = Magazine.new
    @magazine1.channel = channel
    @magazine1.remote_cover_image_url = 'http://harpersbazaar.my/wp-content/uploads/2015/04/harpers-bazaar-malaysia-website-logo.png'
    @magazine1.description = %{Harper’s BAZAAR reports on the runways, beauty’s best, health issues, design innovators and celebrity lives to deliver a sophisticated and diverse array of articles. It offers a Malaysian perspective of the smart and cultured international lifestyles its readers either enjoy or aspire to.}
    @magazine1.title = 'Harper’s BAZZAR Malaysia'
    @magazine1.save

    @magazine2 = Magazine.new
    @magazine2.channel = channel
    @magazine2.remote_cover_image_url = 'http://assets.magzter.com/magazine/1338265843/48/images/original/large_1.jpg'
    @magazine2.description = %{GLAM magazine is Malaysia’s first national-language fashion, beauty and lifestyle authority for the elite high society. Get hot celebrity and society gossip, couture style, premium beauty trends, and insights on the hangouts and obsessions of the rich and famous.}
    @magazine2.title = 'GLAM Malaysia'
    @magazine2.save

    @magazine3 = Magazine.new
    @magazine3.channel = channel
    @magazine3.remote_cover_image_url = 'http://sandbox.nuyou.com.my/wp-content/uploads/2016/04/nuyou-default-image.jpg'
    @magazine3.description = %{NUYOU, Malaysia’s leading Chinese-language fashion and beauty magazine, has been captivating readers with its energy, verve and sophistication since 1993. NUYOU has the scoop on the latest fashion and beauty trends, secrets from the pros and exclusive celebrity tips.}
    @magazine3.title = 'NUYOU Malaysia'
    @magazine3.save

    add_blue_inc_magazines_issues
  end

  def add_blue_inc_magazines_issues
    puts 'Create Blu Inc Media Issues'
    volume1 = @magazine1.volumes.create(year: 2016)

    issue_1 = volume1.issues.create
    issue_1.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/HarperBazaarMalaysia/HarperBazzarMsiaJune.jpg'
    issue_1.title = 'June Issue'
    issue_1.publication_date = Date.new(2016, 06, 01)
    issue_1.url = 'http://harpersbazaar.my/'
    issue_1.save

    issue_2 = volume1.issues.create
    issue_2.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/HarperBazaarMalaysia/HarperBAZAARMsiaMay.jpg'
    issue_2.title = 'May Issue'
    issue_2.publication_date = Date.new(2016, 05, 01)
    issue_2.url = 'http://harpersbazaar.my/?s=May'
    issue_2.save

    issue_3 = volume1.issues.create
    issue_3.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/HarperBazaarMalaysia/HarperBAZAARMsiaApril.jpg'
    issue_3.title = 'April Issue'
    issue_3.publication_date = Date.new(2016, 04, 01)
    issue_3.url = 'https://www.facebook.com/HarpersBAZAARMalaysia'
    issue_3.save

    volume2 = @magazine2.volumes.create(year: 2016)

    issue_4 = volume2.issues.create
    issue_4.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/GlamMalaysia/GLAMMsiaJune.jpg'
    issue_4.title = 'June Issue'
    issue_4.publication_date = Date.new(2016, 06, 01)
    issue_4.url = 'http://glam.my/'
    issue_4.save

    issue_5 = volume2.issues.create
    issue_5.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/GlamMalaysia/GLAMMsiaMay.jpg'
    issue_5.title = 'May Issue'
    issue_5.publication_date = Date.new(2016, 05, 01)
    issue_5.url = 'https://www.facebook.com/GLAMMalaysia/'
    issue_5.save

    volume3 = @magazine3.volumes.create(year: 2016)

    issue_6 = volume3.issues.create
    issue_6.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/NuyouMalaysia/NUYOUMsiaJune.jpg'
    issue_6.title = 'June Issue'
    issue_6.publication_date = Date.new(2016, 06, 01)
    issue_6.url = 'http://nuyou.com.my/'
    issue_6.save

    issue_7 = volume3.issues.create
    issue_7.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/NuyouMalaysia/NUYOUMsiaMay.jpg'
    issue_7.title = 'May Issue'
    issue_7.publication_date = Date.new(2016, 05, 01)
    issue_7.url = 'https://www.facebook.com/www.nuyou.com.my/'
    issue_7.save

    issue_8 = volume3.issues.create
    issue_8.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/BluInc/NuyouMalaysia/NUYOUMsiaApril.jpg'
    issue_8.title = 'April Issue'
    issue_8.publication_date = Date.new(2016, 04, 01)
    issue_8.url = 'https://www.instagram.com/nuyoumalaysia/'
    issue_8.save
  end

  def add_heart_media_magazines
    puts 'Create Heart Media Magazines'
    channel = Channel.find_by!(name: 'Heart Media')

    @magazine6 = Magazine.new
    @magazine6.channel = channel
    @magazine6.remote_cover_image_url = 'http://www.lofficielsingapore.com/wp-content/themes/lofficiel1.1/images/logo.png'
    @magazine6.description = %{This is the Singapore edition of French women's magazine L'OFFICIEL, the world's leading authority across fashion, jewellery, beauty and lifestyle. Catering to the stylish sophisticate, the cultured and the well-heeled, each issue of L'OFFICIEL Singapore features sharp reportage and witty commentary on the latest trends in the world today.}
    @magazine6.title = 'L’OFFICIEL'
    @magazine6.save

    @magazine7 = Magazine.new
    @magazine7.channel = channel
    @magazine7.remote_cover_image_url = 'https://scontent-sin1-1.xx.fbcdn.net/v/t1.0-9/13315312_1017140721668406_3218848910824394916_n.jpg?oh=e409c8a7512a52d3e31c869d2c2dbd75&oe=57D1DE04'
    @magazine7.description = %{For over 16 years, MEN’s FOLIO has been Singapore's premier men’s magazine providing definitive coverage of fashion, style and culture.}
    @magazine7.title = 'MEN’S FOLIO'
    @magazine7.save

    add_heart_media_magazines_issues
  end

  def add_heart_media_magazines_issues
    puts 'Create Heart Media Issues'
    volume1 = @magazine6.volumes.create(year: 2016)

    issue_1 = volume1.issues.create
    issue_1.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/HeartMedia/LOfficielSingapore/LOFFICIELSGJune_July.jpg'
    issue_1.title = 'June/ July Issue'
    issue_1.description = %{We're heading into the wild this June/July '16, from a round-up of fashion's rollercoaster times to the adventurous, dream addresses set to satiate the wanderlust spirit.}
    issue_1.publication_date = Date.new(2016, 06, 01)
    issue_1.url = 'http://www.lofficielsingapore.com/'
    issue_1.save

    issue_2 = volume1.issues.create
    issue_2.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/HeartMedia/LOfficielSingapore/LOFFICIELSGMay.jpg'
    issue_2.title = 'May Issue'
    issue_2.description = %{This May, we celebrate everything beautiful - whether it’s the most cutting-edge offerings this season, mesmerising bijouterie and timepieces, or a breathtaking summer home. Rounding things off, a bumper Beauty section!}
    issue_2.publication_date = Date.new(2016, 05, 01)
    issue_2.url = 'http://www.lofficielsingapore.com/inside-the-may-issue/'
    issue_2.save

    volume2 = @magazine7.volumes.create(year: 2016)

    issue_3 = volume2.issues.create
    issue_3.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/HeartMedia/MenFolioSingapore/MENFOLIOSGJUNEJULY.jpg'
    issue_3.title = 'June/ July Issue'
    issue_3.description = %{If a change of env  ironment and atmosphere at home is what’s needed to lift your mood, the June/July issue of Men’s Folio also has you covered with some tips on how to turn your crib into a hip and cool hangout.. We’ve got a list of recommendations covering the best getaways, spa treatments, smart sleep technology, and even an intermittent fasting diet that will help you to achieve those enviable washboard abs.}
    issue_3.publication_date = Date.new(2016, 06, 01)
    issue_3.url = 'www.mens-folio.com'
    issue_3.save

    issue_4 = volume2.issues.create
    issue_4.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/HeartMedia/MenFolioSingapore/MENFOLIOSGMAY.jpg'
    issue_4.title = 'May Issue'
    issue_4.description = %{South Korean actor Ji Chang-wook, wears Dunhill in this month's issue of Men's Folio out this month together with a special "Accessories Edition".}
    issue_4.publication_date = Date.new(2016, 05, 01)
    issue_4.url = 'https://www.facebook.com/mensfoliosg/'
    issue_4.save
  end

  def add_tree_dance_magazines
    puts 'Create Tree Dance Magazines'
    channel = Channel.find_by!(name: 'Tree Dance')

    @magazine8 = Magazine.new
    @magazine8.channel = channel
    @magazine8.remote_cover_image_url = 'http://touchedition.s3.amazonaws.com/asset/565457b2874f5d50525cbafc.png'
    @magazine8.description = %{Her World Thailand is a monthly Thai magazine produced by Tree Dance Publishing Co. Ltd targeted at the female professionals reading market. Covers fashion pieces, write-ups on grooming, lifestyle and personal choices.}
    @magazine8.title = 'Her World Thailand'
    @magazine8.save

    @magazine9 = Magazine.new
    @magazine9.channel = channel
    @magazine9.remote_cover_image_url = 'http://touchedition.s3.amazonaws.com/asset/5604b6e609258aa561bd6b98.png'
    @magazine9.description = %{Madame Figaro Thailand is the Thai version of the French fashion, women’s interest magazine.}
    @magazine9.title = 'Madam Figaro Thailand'
    @magazine9.save

    @magazine10 = Magazine.new
    @magazine10.channel = channel
    @magazine10.remote_cover_image_url = 'http://touchedition.s3.amazonaws.com/asset/55e91be8b11a42820c835811.png'
    @magazine10.description = %{MAXIM Thailand is the Thai Edition of the world’s biggest men’s lifestyle magazine selling more than 4 million copies per month, with 32 editions in 44 countries and growing bigger all the time.MAXIM provides readers with useful service, laugh-out-loud humor and all the help men need in and “affirmational” way, along with very appealing illustrations. The magazine’s MAXIM is simple: Men’s Bible.}
    @magazine10.title = 'Maxim Thailand'
    @magazine10.save

    add_tree_dance_magazines_issues
  end

  def add_tree_dance_magazines_issues
    puts 'Create Tree Dance Issues'
    volume1 = @magazine8.volumes.create(year: 2016)

    issue_1 = volume1.issues.create
    issue_1.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/HerWorldThailand/herworldThaiJune.jpg'
    issue_1.title = 'June Issue'
    issue_1.publication_date = Date.new(2016, 06, 01)
    issue_1.url = 'http://herworldthai.com/'
    issue_1.save

    issue_2 = volume1.issues.create
    issue_2.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/HerWorldThailand/herworldThaiMay.jpg'
    issue_2.title = 'May Issue'
    issue_2.publication_date = Date.new(2016, 05, 01)
    issue_2.url = 'http://herworldthai.com/post/Qa73dtQ/1'
    issue_2.save

    issue_3 = volume1.issues.create
    issue_3.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/HerWorldThailand/herworldThaiApril.jpg'
    issue_3.title = 'April Issue'
    issue_3.publication_date = Date.new(2016, 04, 01)
    issue_3.url = 'http://herworldthai.com/post/Lk517SP/4'
    issue_3.save

    volume2 = @magazine9.volumes.create(year: 2016)

    issue_4 = volume2.issues.create
    issue_4.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/MadameFigaro/MdmFigaroThaiJune.jpg'
    issue_4.title = 'June Issue'
    issue_4.publication_date = Date.new(2016, 06, 01)
    issue_4.url = 'http://madamefigarothai.com/'
    issue_4.save

    issue_5 = volume2.issues.create
    issue_5.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/MadameFigaro/MdmFigaroThaiMay.jpg'
    issue_5.title = 'May Issue'
    issue_5.publication_date = Date.new(2016, 05, 01)
    issue_5.url = 'https://www.facebook.com/madamefigarothailand/'
    issue_5.save

    issue_6 = volume2.issues.create
    issue_6.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/MadameFigaro/MdmFigaroThaiApril.jpg'
    issue_6.title = 'April Issue'
    issue_6.publication_date = Date.new(2016, 04, 01)
    issue_6.url = 'http://madamefigarothai.com/post/0GPRoCL/1'
    issue_6.save

    volume3 = @magazine10.volumes.create(year: 2016)

    issue_7 = volume3.issues.create
    issue_7.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/MaximThailand/MaximThaiJune.jpg'
    issue_7.title = 'June Issue'
    issue_7.publication_date = Date.new(2016, 06, 01)
    issue_7.url = 'http://maximthai.com/'
    issue_7.save

    issue_8 = volume3.issues.create
    issue_8.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/MaximThailand/MaximThaiMay.jpeg'
    issue_8.title = 'May Issue'
    issue_8.publication_date = Date.new(2016, 05, 01)
    issue_8.url = 'http://maximthai.com/search/may'
    issue_8.save

    issue_9 = volume3.issues.create
    issue_9.remote_cover_image_url = 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/magazines/TreeDance/MaximThailand/MaximThaiApril.jpeg'
    issue_9.title = 'April Issue'
    issue_9.publication_date = Date.new(2016, 04, 01)
    issue_9.url = 'https://www.facebook.com/MaximThailand/'
    issue_9.save
  end
end
