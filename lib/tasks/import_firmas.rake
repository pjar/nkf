require 'rake'

namespace :import do
  desc "Import new companies to the db"
  task :categories => :environment do
    old_count = Category.count
    categories = []
    File.open("#{ENV['path']}/kategorie.txt","r") do |f|
      categories = JSON.parse f.gets
    end
    puts "Creating main categories"
    categories.each do |category|
      p category['name']
      Category.create(name: category["name"], main: true)
      puts "ok"
    end
    puts "Stworzono: #{Category.count - old_count}"
  end

  task :sub_categories => :environment do
    Category.all.each do |cat|
      root_dir = "#{ENV['path']}/#{cat.name}"
      Dir.foreach(root_dir) do |item|
        next if item == "." or item == ".."
        name = item.split('.txt').first
        sub_cat = SubCategory.find_by_name(name)
        if sub_cat
          cat.sub_categories.push(sub_cat)
        else
          cat.sub_categories.create(name: name)
        end
        puts "Stworzono #{cat.name} => #{cat.sub_categories.last.name}"
      end
    end
  end

  task :companies => :environment do
    counter = 0
    left = 0
    big_counter = 0
    Category.all.each do |cat|
      counter += Dir.glob("#{ENV['path']}/#{cat.name}/*").size
    end
    Category.all.each do |category|
      root_dir = "#{ENV['path']}/#{category.name}"
      Dir.foreach(root_dir) do |item|
        next if item == "." or item == ".."
        left +=  1
        puts
        puts "#{left} / #{counter}"
        puts
        companies_json = []
        File.open("#{root_dir}/#{item}","r") do |f|
          companies_json = JSON.parse f.gets
        end
        left_companies = 0
        companies_count = companies_json.size
        companies_json.each do |cj|
          cj = JSON.parse cj
          cj['sub_kategoria'] = "#{category.name}/#{item.split('.txt').first}"
          cj['adres'] = ["unknown",'unknown'] if cj['adres'].empty?
          uniq_id = cj['uniq_id'] = cj['name']+"-"+cj['adres'][0]+"-"+cj['sub_kategoria']
          if !Company.find_by_uniq_id(uniq_id)
            cj['address'] = cj['adres'].join(";")
            #nowa_firma.update_attribute("name",nowa_firma.name
            cj.merge!(name: cj['name'][1, nowa_firma.name.length-1])
            #nowa_firma.update_attribute("category_id", category.id)
            cj.merge!(category_id: category.id)
            Company.create(cj)
            left_companies += 1
            big_counter += 1
            puts "#{companies_count - left_companies}                  #{big_counter}"
          else
            puts "D U P L I C A T E"
          end
          #puts "#{fj['website']}"
        end
      end
    end
  end


  task :generate_big_tablica => :environment do
    require 'mechanize'
    agent = Mechanize.new
    big_tablica = []
    puts "Fetching records from database..."
    calosc = Firma.count
    licznik = 0
    ActiveRecord::Base.connection.execute("select uniq_id, link from firmas").each { |ec| big_tablica << ec; licznik += 1; puts "#{calosc - licznik}"  }
    puts "Writing records to file"
    File.open(Dir::pwd+"/all_firmas.txt", "w+") do |f|
      f.write big_tablica.to_json
    end
    #TODO - finish this
  end

  task :emails => :environment do 
    require 'mechanize'
    agent = Mechanize.new
    puts "Fetching records from file..."
    big_tablica = []
    File.open(Dir::pwd+"/all_firmas.txt", "r") do |f|
      big_tablica = JSON.parse f.gets
    end
    puts big_tablica.size
    
    divided_big_tablica = big_tablica.each_slice(100000).to_a
    big_counter = divided_big_tablica.size
    puts "Database loaded, and divided into #{big_counter.to_s} parts" 
    part = ENV['part'].presence
    part = part.to_i
    tablica = []
    if part && (part <= divided_big_tablica.size - 1 || part == 0)
      tablica = divided_big_tablica[part] 
      counter = tablica.size
    else
      raise "invalid part choice, please use number between 0 and #{big_counter - 1}"
    end
    emails = 0
    tablica.each do |item| 
      begin
        page = agent.get item[1]
      rescue Exception => e
        puts e
        File.open(Dir::pwd+"/errors.log","a+") do |f|
          f.write(item[0]+"$$")
        end
        next
      end
      email = page.search("div.js-infopagePopupArea a").first.try(:text) || " "
      description = page.search("div.announcement").first.try(:text)
      if email.presence
        File.open(Dir::pwd+"/emails_acquired.txt","a+") do |f|
          f.write(item[0]+"**"+email+"$$")
        end
        firma = Firma.find_by_uniq_id(item[0])
        firma.update_attribute("email", email)
        firma.update_attribute("description", description)
        emails += 1
      end
      File.open(Dir::pwd+"/email_checked.txt","a+") do |f|
        f.write(item[0]+"**"+email+"$$")
      end
      counter -= 1
      puts "#{counter}         #{emails}" 
    end
  end

  task :firmas_with_emails_only => :environment do
    already_checked = Firma.all.map{ |f| "#{f.uniq_id}**#{f.email}"}
    puts "Zmapowano istniejace juz firmy, ilosc: #{already_checked.size}"
    emails_list = []
    counter = 1
    File.open(Dir::pwd+"/emails_acquired.txt","r") do |f|
      emails_list = f.gets
    end
    emails_list = emails_list.split("$$")
    puts "Zaladowano juz zrobione firmy z pliku, ilosc: #{emails_list.size}"
    emails_list = emails_list - already_checked
    pozostalo = emails_list.size
    puts "Usunieto z listy do sprawdzenia wszystkie utworzone dotad firm. Pozostalo: #{pozostalo}"
    kategoria = Category.find(ENV['kat_index'].to_i)
    root_dir = "#{ENV['path']}/#{kategoria.name}"
    Dir.foreach(root_dir) do |item|
      next if item == "." or item == ".."
      counter += 0
      if ENV['omit']
        puts "Omijam #{counter}"
        next if counter < ENV['omit'].to_i
      end
      firmy_json = []
      File.open("#{root_dir}/#{item}","r") do |f|
        firmy_json = JSON.parse f.gets
      end
      firmy_json.each do |fj|
        fj = JSON.parse fj
        fj['sub_kategoria'] = "#{kategoria.name}/#{item.split('.txt').first}"
        fj['adres'] = ["unknown",'unknown'] if fj['adres'].empty?
        uniq_id = fj['uniq_id'] = fj['name']+"-"+fj['adres'][0]+"-"+fj['sub_kategoria']
        firma_with_email = emails_list.detect{ |el| el.split("**").first == uniq_id }
        added_firmas = ""
        if File.file?(Dir::pwd+"/added_firmas.txt")
          File.open(Dir::pwd+"/added_firmas.txt","r") do |f|
            added_firmas = f.gets
          end
        end
        if firma_with_email && !added_firmas.include?(uniq_id)
          fj['adres'] = fj['adres'].join(";")
          nowa_firma = Firma.create(fj)#:name => fj['name'][1, fj['name'].length-1], :adres => fj['adres'], :tel   => fj['tel'], :fax   => fj['fax'], :link  => fj['link'], :description => fj['description'], :website => fj['website'])
          nowa_firma.update_attribute("name",nowa_firma.name[1, nowa_firma.name.length-1])
          nowa_firma.update_attribute("kategoria_id", kategoria.id)
          nowa_firma.update_attribute("email", firma_with_email.split("**").last)
          nowa_firma.update_attribute("pod_kategoria_id", SubCategory.find_by_nazwa(firma_with_email.split("**").first.split("/").last).id)
          puts firma_with_email.split("**").first.split("/").last
          emails_list.delete(firma_with_email)
          File.open(Dir::pwd+"/added_firmas.txt","a+") do |f|
            f.write(nowa_firma.uniq_id)
          end

        end
        #puts "#{fj['website']}"
      end
    end
  end
end
